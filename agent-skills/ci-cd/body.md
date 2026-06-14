## Pipeline Design Principles

Before writing any config:
1. **Build once** — the same artifact (image, binary) must be promoted through all environments unchanged
2. **Fail fast** — run cheapest checks first (lint → unit tests → build → integration → deploy)
3. **Explicit promotion gates** — dev auto-deploys; staging requires tests passing; production requires manual approval or canary success
4. **Reproducible builds** — pin all tool versions (Node, Go, Docker base image tag, action versions)

## Docker Multi-Stage Builds

Use separate stages for dev, test, and prod. Never ship dev tools or test fixtures in the production image.

```dockerfile
# Build stage — full toolchain
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download              # cached layer — only invalidated when go.sum changes
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /bin/server ./cmd/server

# Test stage — runs in CI, not shipped
FROM builder AS test
RUN go test ./...

# Production stage — minimal attack surface
FROM gcr.io/distroless/static-debian12 AS production
COPY --from=builder /bin/server /server
USER nonroot:nonroot
EXPOSE 8080
ENTRYPOINT ["/server"]
```

Key rules:
- Pin base image tags to a digest or version, never `latest`
- Use `distroless` or `scratch` for Go/static binaries; `slim` variants for interpreted languages
- Run as non-root in production stage
- Order layers cheapest-to-change last (dependencies before source code)
- Never `COPY . .` before installing dependencies — it breaks caching

## Deployment Strategies

| Strategy | When to use | Rollback time | Risk |
|---|---|---|---|
| **Rolling** | Stateless services, tolerates mixed versions briefly | Seconds (re-deploy previous) | Low — gradual, no downtime |
| **Blue-green** | Zero-downtime required, stateful schema migrations complete | Instant (flip load balancer) | Medium — requires 2× resources |
| **Canary** | Risk reduction on high-traffic path, A/B needs | Minutes (redirect traffic) | Low — gradual exposure |

**Blue-green pattern:**
- Blue = current production; Green = new version
- Deploy to Green, run smoke tests, shift traffic atomically (load balancer weight)
- Keep Blue running for fast rollback; terminate after confidence window

**Canary pattern:**
- Route 5% of traffic to canary, monitor error rate and latency for N minutes
- Auto-promote if metrics are healthy; auto-rollback if thresholds exceeded
- In Kubernetes: use two Deployments + weighted Service or an ingress with traffic splitting

## GitHub Actions Pipeline

Standard structure for a Go or TypeScript service:

```yaml
name: CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5     # pin to major version
        with:
          go-version-file: go.mod
          cache: true
      - run: go test ./... -race -coverprofile=coverage.out
      - run: go vet ./...

  build:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    outputs:
      image: ${{ steps.meta.outputs.tags }}
      digest: ${{ steps.push.outputs.digest }}
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=sha,prefix=sha-
            type=raw,value=latest,enable={{is_default_branch}}
      - id: push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
          target: production

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - name: Update image tag in GitOps repo
        run: |
          # Use image digest for immutable reference
          echo "${{ needs.build.outputs.digest }}" > deploy/staging/image-digest.txt
          git config user.email "ci@github.com"
          git config user.name "CI"
          git add deploy/staging/
          git commit -m "deploy: update staging to ${{ github.sha }}"
          git push
```

## GitOps with ArgoCD / Kargo

**App-of-apps pattern** — one root Application manages all others:

```yaml
# argocd/root.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/org/infra
    targetRevision: HEAD
    path: argocd/apps
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

**Kargo promotion pipeline** (dev → staging → production):
- Define `Stage` resources per environment
- Use `Freight` to track image + git commit pairs
- Promotion from staging → production requires manual approval or automated verification gate
- Rollback = promote previous Freight — no special rollback command needed

**Sync policies:**
- Dev: `automated.selfHeal: true`, `automated.prune: true`
- Staging: `automated.selfHeal: true`, manual sync for destructive changes
- Production: manual sync only; require PR approval before git push

## Secret Management

Secrets must never be:
- In Docker images (not even in build args — visible in layer history)
- Committed to git (not even in `.env.example` with real values)
- In Kubernetes ConfigMaps (ConfigMaps are not encrypted at rest by default)

Approved patterns in order of preference:

1. **External Secrets Operator + provider vault** (AWS Secrets Manager, GCP Secret Manager, HashiCorp Vault) — syncs secrets into K8s Secrets automatically
2. **Kubernetes Secrets with sealed-secrets** (Bitnami) — encrypted at rest, safe to commit
3. **CI/CD environment variables** (GitHub Actions secrets) — for CI-only credentials

For M-Pesa, Paystack, and other African payment provider keys: treat the same as Stripe keys — never in source, always in a secret store.

## Environment Promotion

Define explicit promotion criteria — not just "tests pass":

| Gate | Staging | Production |
|---|---|---|
| Unit + integration tests | required | required |
| Security scan (image + SAST) | required | required |
| Smoke tests against deployed service | required | required |
| Load test above baseline | recommended | required |
| Manual approval | no | yes |
| Canary window | no | 15 min at 5% |

## Rollback Procedure

Every deployment must have a defined rollback:

1. **Immediate** (< 1 min): flip load balancer to previous blue deployment (blue-green only)
2. **GitOps rollback** (< 5 min): promote previous Freight in Kargo / sync previous commit in ArgoCD
3. **Image rollback** (< 10 min): update image tag in GitOps repo to previous digest, push, ArgoCD syncs

Definition of "done" for a deployment:
- Health checks pass on all pods
- Error rate and latency within baseline ± 10% for 5 minutes
- No increase in critical log patterns
- Smoke tests pass against production endpoint

## Quality Bar

- Every deployment must have a documented rollback procedure before it goes to production
- Image tags must be immutable — use digest (`sha256:...`) in production manifests, not `latest`
- Secrets must never appear in CI logs — mask them and verify with a grep on the log
- Pipeline must run in under 10 minutes for the test and build stages; investigate if it exceeds 15
- Staging must be structurally identical to production (same manifest, different values)

## Anti-Patterns

- **`latest` image tag in production** — undetermined what's running; use digest or explicit version tag
- **`kubectl apply` in CI without GitOps** — push-based deployments bypass audit trail and drift detection
- **Secrets in image build args** — visible in `docker history`; use secret mounts or external secret stores
- **No promotion gate** — auto-deploying to production on every push without tests or approval
- **Monolithic pipeline** — one job that tests, builds, and deploys; split so failures are attributable
- **Shared service accounts across environments** — production and staging must use separate credentials
- **Missing health checks** — deploying without readiness/liveness probes means Kubernetes can't detect a broken rollout
