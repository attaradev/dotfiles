## Architecture Process

Work in order — don't jump to IaC before the design is clear:

1. **Requirements** — workload type, traffic profile, data residency, compliance needs, budget
2. **Service boundaries** — which components need independent scaling or isolated failure domains
3. **Topology** — regions, availability zones, network layout
4. **IaC structure** — Terraform module layout, state management
5. **Security posture** — IAM, network policies, secret management
6. **Cost model** — estimate before provisioning; right-size from the start

## Terraform Structure

Organise by environment and responsibility, not by resource type:

```
infra/
├── modules/             # Reusable modules (no state)
│   ├── gke-cluster/
│   ├── vpc/
│   └── external-secrets/
├── environments/
│   ├── staging/
│   │   ├── main.tf      # Calls modules
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── backend.tf   # Remote state (GCS/S3)
│   └── production/
│       └── ...
└── global/              # DNS, IAM roles shared across environments
```

**State management:**
- Remote state only — never local (lost on CI runner reset, no locking)
- One state file per environment per responsibility domain (networking, cluster, apps)
- State locking: GCS with `filestore.lock` or S3 with DynamoDB table
- Never store secrets in state — use data sources and secret references instead

**Module rules:**
- Every module has: `variables.tf`, `outputs.tf`, `main.tf`, `versions.tf`
- Pin provider versions in `versions.tf` with `~>` constraint (minor-version flexibility, not major)
- No hard-coded values in modules — everything parameterised
- Outputs expose only what callers need; don't leak internal resource IDs unnecessarily

## Kubernetes Cluster Design

**Node pool strategy** — separate pools by workload type:

| Pool | Machine type | Purpose |
|---|---|---|
| System | n2-standard-2 (2 vCPU, 8 GB) | kube-system, ArgoCD, monitoring |
| Application | n2-standard-4 or e2-standard-4 | General workloads |
| Spot/Preemptible | same family | Batch, queue workers, non-critical |

**Resource requests and limits** — required on every Deployment:
- Request = what the pod needs to schedule; must reflect actual steady-state usage
- Limit = ceiling; for CPU, prefer no limit (throttling is worse than eviction); for memory, set limit ≤ 2× request
- Use VPA in recommendation mode before setting production values

**Namespace strategy:**
- One namespace per team or bounded context, not per microservice
- `kube-system`: cluster infrastructure only
- `monitoring`: Prometheus, Grafana, alertmanager
- Network policies: default deny all, explicit allow per namespace

**Ingress:**
- One ingress controller per cluster (nginx or Gateway API); don't mix
- TLS termination at ingress; cert-manager with Let's Encrypt for non-production, managed cert for production
- Rate limiting and WAF rules at ingress level, not application level

## GitOps Architecture (ArgoCD / Kargo)

**App-of-apps structure:**

```
gitops-repo/
├── argocd/
│   ├── root-app.yaml          # Manages everything below
│   └── apps/
│       ├── monitoring.yaml
│       ├── external-secrets.yaml
│       └── services/
│           ├── api.yaml
│           └── worker.yaml
└── environments/
    ├── staging/
    │   └── services/api/
    │       ├── deployment.yaml
    │       └── values.yaml    # Environment-specific overrides
    └── production/
        └── services/api/
```

**Kargo promotion pipeline:**
- `Warehouse` watches image registry + git repo for new artifacts
- `Freight` bundles a specific image digest with the git commit that produced it
- `Stage` (dev → staging → production) defines promotion criteria and approval requirements
- Production stage requires manual approval; staging auto-promotes when health checks pass

**Sync policies by environment:**
- Dev: `selfHeal: true`, `prune: true` — ArgoCD reconciles drift automatically
- Staging: `selfHeal: true`, manual prune — prevents accidental deletion
- Production: no automated sync — all changes via explicit sync after review

## Network Topology

**VPC layout (multi-environment):**
```
VPC (10.0.0.0/16)
├── Public subnets (10.0.0.0/24, 10.0.1.0/24)  — load balancers only
├── Private subnets (10.0.10.0/23, 10.0.12.0/23) — application pods
└── Database subnets (10.0.20.0/24, 10.0.21.0/24) — no direct egress
```

Rules:
- Applications never in public subnets — only load balancers and NAT gateways
- Database subnets have no direct internet access
- Separate VPCs per environment; VPC peering or Transit Gateway for shared services
- Kubernetes Pod CIDR must not overlap with VPC CIDR or VPN ranges

## Auto-Scaling

| Autoscaler | Controls | When to use |
|---|---|---|
| HPA (Horizontal Pod Autoscaler) | Pod replica count | CPU/memory or custom metrics (RPS, queue depth) |
| VPA (Vertical Pod Autoscaler) | Pod resource requests | Right-sizing; use in recommendation mode first |
| KEDA | Event-driven scaling | Scale to zero for queue workers; Kafka consumer groups |
| Cluster Autoscaler | Node count | Add/remove nodes based on pending pods |

HPA configuration:
- Target CPU utilisation at 60–70% (not 80%+; allows headroom for burst)
- Set `stabilizationWindowSeconds` to prevent thrashing (300s scale-down, 60s scale-up)
- Use custom metrics (queue depth, RPS) over CPU when possible — CPU lags workload signals

## Cost Optimization

In order of impact:

1. **Spot/preemptible nodes** — 60–80% savings for stateless, fault-tolerant workloads (batch, workers)
2. **Right-size requests** — over-provisioned requests waste capacity; use VPA recommendations
3. **Committed use / reserved instances** — for baseline capacity that runs 24/7; 30–50% savings
4. **Auto-scale to zero** — KEDA for queue workers; idle environments
5. **Storage class selection** — standard persistent disk for non-latency-sensitive; don't use SSD for logs
6. **Egress costs** — keep inter-service traffic within region; avoid cross-region calls in hot paths

Set budget alerts at 80% and 100% of expected monthly spend. Review cost attribution by namespace using labels.

## Disaster Recovery

Define RTO and RPO before designing DR — they determine the architecture:

| Target | RTO | RPO | Architecture |
|---|---|---|---|
| Best-effort | Hours | Hours | Backup + restore |
| Business-critical | < 1 hour | < 15 min | Warm standby (secondary region, scaled down) |
| Mission-critical | < 5 min | 0 (synchronous replication) | Active-active multi-region |

**DR runbook template (include in every service):**
1. **Trigger criteria** — what metrics or events declare a disaster (e.g., primary region unavailable for > 5 min)
2. **Failover steps** — ordered, numbered, runnable by on-call without debugging
3. **DNS cutover** — TTL must be set to 60s before any DR event; don't change it during
4. **Data validation** — steps to verify data integrity in secondary before accepting traffic
5. **Communication** — who is notified, in what order, via what channel
6. **Recovery** — how to fail back to primary once restored

## Security Defaults

Apply these to every new cluster/environment:

- **Least-privilege IAM** — workload identity / pod identity for cloud API access; no shared service account keys on disk
- **Network policies** — default deny all ingress and egress; explicit allow per service
- **Secret management** — External Secrets Operator syncing from cloud secret manager; no Kubernetes Secrets created manually
- **Image scanning** — scan every image on push (Trivy in CI) and on admission (Kyverno or OPA Gatekeeper)
- **Pod security standards** — enforce `restricted` profile; no privileged containers, no host namespace sharing
- **Audit logging** — enable Kubernetes audit logs; forward to centralised logging with 90-day retention

## Monitoring Structure

Separate infra metrics from application metrics:

| Layer | What to monitor | Tool |
|---|---|---|
| Infrastructure | Node CPU/memory, disk, network, pod restarts | Prometheus + node-exporter |
| Application | Request rate, error rate, latency (p50/p99) | Prometheus (app instrumentation) |
| Platform | ArgoCD sync status, deployment frequency | ArgoCD metrics |
| Cost | Per-namespace spend, idle capacity | Cloud billing export + dashboard |

**Four golden signals** — the minimum alert set for every service:
1. **Latency** — p99 > 500ms for 5 min
2. **Error rate** — > 1% errors over 5 min
3. **Traffic** — sudden drop (> 50% from baseline) — often a routing or deployment issue
4. **Saturation** — CPU > 80% or memory > 90% for > 10 min

## Quality Bar

- Every environment must have a DR runbook before receiving production traffic
- Terraform plan must be reviewed and approved before apply — never `terraform apply` without a reviewed plan
- Image tags in production manifests must be digests (`sha256:...`), never floating tags
- All secrets must be in the external secret store before the service is deployed — no manual `kubectl create secret`
- Cost estimate required before any new infrastructure is provisioned

## Anti-Patterns

- **Manual `kubectl` commands in production** — all state must be in git; kubectl bypasses audit trail and GitOps reconciliation
- **Shared credentials across environments** — staging workloads with production database access is a blast-radius disaster
- **`latest` in Kubernetes manifests** — kills rollback capability and makes it impossible to know what's running
- **Monolithic Terraform state** — one state file for everything means one plan takes 10 minutes and a mistake destroys everything
- **No resource requests** — scheduler can't make placement decisions; leads to overloaded nodes and OOM kills
- **Skipping VPA recommendations** — setting requests by intuition leads to 3-5× over-provisioning
- **DNS TTL > 60s during DR** — high TTL means DNS cutover takes hours, not seconds
- **Cluster-admin for application service accounts** — every workload gets only the permissions it actually needs
