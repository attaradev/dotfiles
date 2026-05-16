# Kubernetes Manifest Review Checklist

## 1. Security

### Container security context

```yaml
securityContext:
  runAsNonRoot: true          # Critical: never run as root
  runAsUser: 1000             # High: explicit UID
  runAsGroup: 1000
  readOnlyRootFilesystem: true  # High: prevents writes to container fs
  allowPrivilegeEscalation: false  # Critical: blocks setuid escalation
  capabilities:
    drop: ["ALL"]             # High: drop all Linux capabilities
    add: ["NET_BIND_SERVICE"] # Only re-add what is genuinely needed
```

| Check | Severity | Issue |
|-------|----------|-------|
| `runAsNonRoot: false` or missing | Critical | Container may run as root; compromise = node-level access |
| `allowPrivilegeEscalation: true` or missing | Critical | Allows setuid/setgid escalation |
| `readOnlyRootFilesystem` missing | High | Attacker can write files, install tools |
| No `capabilities.drop: ["ALL"]` | High | Retains dangerous Linux capabilities by default |
| `privileged: true` | Critical | Equivalent to root on the node |

### Image

| Check | Severity | Issue |
|-------|----------|-------|
| `image: myapp:latest` | High | No reproducibility; silent updates |
| No image digest pin | Medium | Tag can be overwritten by registry push |
| Image from unverified registry | High | Supply chain risk |

Fix: use digest-pinned images in production: `myapp:1.2.3@sha256:abc123...`

### Secrets

| Check | Severity | Issue |
|-------|----------|-------|
| Secret value in `env.value` plain text | Critical | Secret in manifest, likely in git |
| Secret in `configMap` | High | ConfigMaps are not encrypted at rest by default |

Fix:
```yaml
env:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: password
```

---

## 2. Reliability

### Health probes

Every Deployment/StatefulSet container must have both probes:

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 10
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /readyz
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
  failureThreshold: 3
```

| Check | Severity | Issue |
|-------|----------|-------|
| No `readinessProbe` | High | Traffic sent to pods not yet ready |
| No `livenessProbe` | Medium | Stuck pods never restarted |
| `livenessProbe` same path as `readinessProbe` | Medium | Liveness kills pod when it should just remove it from LB |
| `initialDelaySeconds` too low | Medium | Probe fires before app starts; restart loop |

### Restart and disruption

```yaml
# Deployment strategy
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 0    # Zero downtime
    maxSurge: 1

# Pod disruption budget (separate resource)
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: myapp-pdb
spec:
  minAvailable: 1        # or maxUnavailable: 1
  selector:
    matchLabels:
      app: myapp
```

| Check | Severity | Issue |
|-------|----------|-------|
| No PodDisruptionBudget for stateful/critical workloads | High | Node drain can take all pods offline simultaneously |
| `maxUnavailable: 100%` | High | Full outage during rolling update |
| `replicas: 1` without explicit justification | Medium | No redundancy; single point of failure |

---

## 3. Resource management

```yaml
resources:
  requests:
    cpu: "250m"
    memory: "256Mi"
  limits:
    cpu: "1000m"
    memory: "512Mi"
```

| Check | Severity | Issue |
|-------|----------|-------|
| No `resources.requests` | High | Pod scheduled on any node; may starve others |
| No `resources.limits.memory` | High | OOM kill of other pods on the node |
| `limits.cpu` set very low | Medium | CPU throttling causes latency spikes |
| `requests == limits` (Guaranteed QoS) | Low | Fine for critical apps; note intentional |
| No `limits.memory` | High | Unbounded memory growth kills node |

---

## 4. Networking

### Service

| Check | Severity | Issue |
|-------|----------|-------|
| `type: NodePort` in production | Medium | Exposes random port on all nodes |
| `type: LoadBalancer` without annotations | Medium | Creates public LB by default in cloud |
| No `targetPort` specified | Low | Relies on naming convention; fragile |

### NetworkPolicy

For any workload that handles sensitive data or should not be freely reachable:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: myapp-netpol
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - port: 8080
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: postgres
      ports:
        - port: 5432
```

| Check | Severity | Issue |
|-------|----------|-------|
| No NetworkPolicy for sensitive workload | High | Any pod in the cluster can reach it |
| Overly broad ingress (`from: []`) | High | Open to all cluster traffic |

---

## 5. RBAC

```yaml
# Least-privilege ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: myapp
  namespace: production
automountServiceAccountToken: false  # disable if not needed
```

| Check | Severity | Issue |
|-------|----------|-------|
| `automountServiceAccountToken` not false | Medium | Pod gets API token it may not need |
| ClusterRole where Role would suffice | High | Grants cluster-wide permissions unnecessarily |
| `verbs: ["*"]` in Role | High | Grants all operations on the resource |
| `resources: ["*"]` in Role | Critical | Grants access to every resource type |

---

## 6. Observability

| Check | Severity | Issue |
|-------|----------|-------|
| No `app` or `version` labels | Medium | Cannot filter metrics/logs by app version |
| No annotations for Prometheus scraping | Low | Metrics not collected |
| No structured logging configuration | Low | Log aggregation may fail |

Standard labels:
```yaml
labels:
  app: myapp
  version: "1.2.3"
  component: api
  managed-by: helm
```

---

## 7. Operational readiness

| Check | Severity | Issue |
|-------|----------|-------|
| No `namespace` set | Medium | Defaults to `default` namespace; no isolation |
| No `terminationGracePeriodSeconds` | Low | Default 30s may be too short or too long |
| `hostNetwork: true` | High | Pod shares node network namespace |
| `hostPID: true` | Critical | Pod can see all node processes |
| `hostPath` volume without justification | High | Direct node filesystem access |
| No `podAntiAffinity` for multi-replica deployments | Medium | All replicas may land on same node |

Recommended anti-affinity for HA:
```yaml
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app: myapp
          topologyKey: kubernetes.io/hostname
```
