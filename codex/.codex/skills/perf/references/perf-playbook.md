# Performance Investigation Playbook

## Step 1: Define the problem precisely

Vague: "The API is slow."
Precise: "The `GET /reports/{id}` endpoint has a p99 latency of 4.2s; acceptable is < 500ms. It serves 200 req/s at peak."

Before investigating, establish:
- Which operation? (endpoint, function, query, job)
- What metric? (p50, p99, throughput, memory, CPU)
- What is the current measurement?
- What is the target?
- At what load? (single user, peak traffic, batch job)

---

## Step 2: Establish a baseline

Never optimise without a before measurement. You cannot know if you helped without one.

### Profiling tools by language

**Go**
```sh
# CPU profile
go test -bench=BenchmarkMyFunc -cpuprofile=cpu.prof ./...
go tool pprof cpu.prof

# Memory profile
go test -bench=. -memprofile=mem.prof ./...
go tool pprof mem.prof

# HTTP endpoint (net/http/pprof)
curl http://localhost:6060/debug/pprof/profile?seconds=30 -o cpu.prof
go tool pprof -http=:8080 cpu.prof
```

**Python**
```sh
python -m cProfile -o output.prof my_script.py
python -m pstats output.prof  # interactive
pip install snakeviz && snakeviz output.prof  # visual flamegraph
```

**Node.js**
```sh
node --prof app.js          # V8 profile
node --prof-process isolate-*.log > processed.txt
# Or: clinic.js flame -- node app.js
```

**Database queries**
```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) SELECT ...;
```

---

## Step 3: Bottleneck taxonomy

| Bottleneck | Signals | Investigation |
|-----------|---------|--------------|
| CPU-bound | 100% CPU, flamegraph shows wide hot frames | Profile CPU; look for tight loops, regex, serialisation |
| Memory-bound | GC pressure, OOM, high allocation rate | Memory profile; look for allocations in hot path |
| I/O-bound | High iowait, slow disk reads | strace, iotop; check buffering, batch reads |
| Network-bound | High latency to external service, small payloads | Check connection reuse, DNS, TCP handshake overhead |
| Lock contention | Goroutines/threads blocked, mutex hotspot | Mutex profile (Go), thread dump (JVM) |
| DB queries | Slow query log, missing index, N+1 | EXPLAIN ANALYZE, query log, APM trace |
| Algorithmic | O(n²) with large n, nested loops | Code review; complexity analysis |
| Serialisation | JSON marshal/unmarshal in hot path | Benchmark encoding; consider binary format or schema-based codec |

---

## Step 4: Common performance anti-patterns

### Algorithmic

| Anti-pattern | Fix |
|-------------|-----|
| O(n²) nested loops over large collections | Sort + binary search; hash map lookup |
| Linear search in a hot path | Index the collection; use a set/map |
| Repeated computation of the same value | Cache the result; move computation outside the loop |
| Sorting on every request | Sort once at write time; maintain sorted order |

### Memory allocation

| Anti-pattern | Fix |
|-------------|-----|
| Allocating inside a tight loop | Pre-allocate with known capacity; sync.Pool for reuse |
| Large temporary allocations | Stream instead of buffer; process in chunks |
| String concatenation in a loop | strings.Builder (Go), StringBuilder (Java), join (Python) |
| Copying large slices/arrays | Use pointers or slices of the original |

### I/O and network

| Anti-pattern | Fix |
|-------------|-----|
| Unbuffered reads/writes | Wrap in bufio (Go), BufferedReader (Java), io.BufferedWriter (Python) |
| Opening a new connection per request | Connection pooling; persistent connections |
| Serial external calls | Parallel with goroutines/async; fan-out |
| Fetching more data than needed | SELECT only required columns; paginate; push filtering to DB |
| No caching for stable data | Add a TTL cache; use Redis for shared cache |

### Database specific

| Anti-pattern | Fix |
|-------------|-----|
| N+1 queries | Batch fetch; JOIN; eager loading |
| Missing index | EXPLAIN ANALYZE; add index CONCURRENTLY |
| Fetching all columns (`SELECT *`) | Specify columns; enables index-only scans |
| Unbounded result set | Add LIMIT; paginate |
| Auto-commit per row in bulk insert | Batch in a single transaction |

---

## Step 5: Measurement and validation

Always measure before and after with the same method.

### Benchmarking patterns

**Go**
```go
func BenchmarkMyFunc(b *testing.B) {
    // Setup outside the loop
    input := prepareInput()
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        MyFunc(input)
    }
}
// Run: go test -bench=BenchmarkMyFunc -benchmem -count=5 ./...
// -benchmem shows allocation count and bytes per op
// -count=5 runs 5 times for statistical stability
```

**Python**
```python
import timeit
result = timeit.timeit('my_func(input)', setup='...', number=10000)
# Or: pytest-benchmark for integrated benchmark tracking
```

**Load testing (endpoint)**
```sh
# hey (Go)
hey -n 10000 -c 100 http://localhost:8080/api/reports/1

# wrk
wrk -t4 -c100 -d30s http://localhost:8080/api/reports/1

# k6
k6 run --vus 100 --duration 30s script.js
```

### Reporting improvement

State results with concrete numbers:

| Metric | Before | After | Improvement |
|--------|--------|-------|------------|
| p50 latency | 180ms | 12ms | 93% reduction |
| p99 latency | 4200ms | 38ms | 99% reduction |
| Throughput | 48 req/s | 620 req/s | 13× |
| Memory per request | 18 MB | 1.2 MB | 93% reduction |
| Allocations per op | 4,200 | 3 | 99.9% reduction |

---

## Quick wins checklist

Before deep profiling, check these common easy wins:

- [ ] Is caching in place for data that changes rarely?
- [ ] Are database queries using indexes? (EXPLAIN ANALYZE)
- [ ] Are external service calls made in parallel or serial?
- [ ] Is connection pooling enabled and properly sized?
- [ ] Are responses compressed (gzip/br for HTTP)?
- [ ] Is pagination enforced on list endpoints?
- [ ] Are large objects streamed or buffered in full?
- [ ] Is serialisation happening on the hot path? (JSON is expensive at scale)
