# C4 Model Conventions

## The four levels

| Level | Question answered | Audience | Mermaid type |
|-------|-----------------|---------|-------------|
| 1 — System Context | What does the system do and who interacts with it? | Everyone | `C4Context` |
| 2 — Container | What are the deployable units and how do they communicate? | Developers, architects | `C4Container` |
| 3 — Component | What are the major structural blocks inside a container? | Developers | `C4Component` |
| 4 — Code | How is a component implemented? | Developers (rarely diagrammed) | Class/sequence diagrams |

Start at Level 1, always include Level 2, add Level 3 only when asked to zoom in.

---

## Mermaid syntax

### Level 1 — System Context

```
C4Context
  title System Context: [System Name]

  Person(alias, "Label", "Description")
  System(alias, "Label", "Description")
  System_Ext(alias, "Label", "Description")

  Rel(from, to, "Label", "Technology")
  Rel_Back(from, to, "Label", "Technology")
  BiRel(from, to, "Label", "Technology")

  UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

### Level 2 — Container

```
C4Container
  title Container Diagram: [System Name]

  Person(alias, "Label", "Description")
  System_Ext(alias, "Label", "Description")

  System_Boundary(sys_alias, "System Name") {
    Container(alias, "Label", "Technology", "Description")
    ContainerDb(alias, "Label", "Technology", "Description")
    ContainerQueue(alias, "Label", "Technology", "Description")
  }

  Rel(from, to, "Label", "Technology / Protocol")
```

### Level 3 — Component

```
C4Component
  title Component Diagram: [Container Name]

  Container_Ext(alias, "Label", "Technology", "Description")

  Container_Boundary(con_alias, "Container Name") {
    Component(alias, "Label", "Technology", "Description")
  }

  Rel(from, to, "Label")
```

---

## Element types and when to use them

| Element | Use for |
|---------|---------|
| `Person` | Human users — internal or external |
| `System` | The system being described |
| `System_Ext` | External systems outside your control |
| `Container` | Deployable unit: web app, API, worker, CLI |
| `ContainerDb` | Database, data store, file system |
| `ContainerQueue` | Message queue, event bus, stream |
| `Component` | Major structural building block within a container |

---

## Relationship rules

Every `Rel` must have:
1. **Direction** — who initiates the call
2. **Label** — what data or action flows ("submits order", "reads user record")
3. **Technology** — the protocol or mechanism ("HTTPS/JSON", "gRPC", "AMQP", "SQL")

Avoid:
- `Rel(a, b, "uses")` — says nothing
- `Rel(a, b, "calls API")` — which API? which protocol?
- Bidirectional arrows where one direction is clearly primary

---

## Narrative template (per diagram)

After each diagram, write:

**What this shows:** [One sentence describing the scope of this diagram]

**Key flows:** [2–3 bullet points describing the most important interactions]

**Non-obvious decisions:** [Any architectural choices that would surprise a new engineer — why async vs sync, why a queue here, why this external dependency]

**Assumptions:** [Anything inferred from context rather than confirmed from code]

---

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Too many elements at Level 1 | Level 1 should have at most 5–8 elements; collapse internal components into one System box |
| Database inside Person boundary | Databases are containers, not people |
| Arrows without labels | Every arrow needs a verb and a protocol |
| Showing internal classes at Level 2 | Level 2 shows containers (deployable units), not internal code structure |
| Missing external systems | Every integration your system makes must appear, even if it is not your code |
