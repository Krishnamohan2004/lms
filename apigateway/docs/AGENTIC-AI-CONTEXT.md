# Agentic AI Context

## Repository Map

```
apigateway/
├── pom.xml                          # Maven build definition, all dependencies
├── src/main/java/com/learningplatform/apigateway/
│   ├── ApigatewayApplication.java   # Spring Boot entry point
│   └── security/
│       ├── JwtAuthFilter.java       # Global filter: auth enforcement, header injection
│       └── JwtUtil.java             # JWT parsing and validation utility
├── src/main/resources/
│   └── application.yml              # Routes, Eureka config, JWT secret
├── src/test/java/                   # Test sources
└── docs/                            # Project documentation
```

## Domain Glossary

| Term | Definition |
|------|-----------|
| API Gateway | Single entry point for all client requests to the platform |
| Route | A mapping from an incoming path pattern to a downstream service |
| Predicate | A condition (e.g., path pattern) that determines if a route matches |
| Global Filter | A filter that executes on every request passing through the gateway |
| Eureka | Netflix service discovery server; services register and discover each other |
| Load Balancer (lb://) | Client-side load balancing using Eureka-registered instances |
| JWT | JSON Web Token; used for stateless authentication |
| Claims | Key-value pairs encoded in a JWT (e.g., subject, role) |
| Circuit Breaker | Pattern that stops calling a failing service to prevent cascading failure |
| X-User-Id | Custom header injected by gateway containing authenticated user's ID |
| X-User-Role | Custom header injected by gateway containing authenticated user's role |
| Public Endpoint | Route that does not require authentication |

## Critical Files and Ownership

| File | Criticality | Change Impact | Owner |
|------|-------------|---------------|-------|
| `application.yml` | High | All routing and service discovery | Tech Lead |
| `JwtAuthFilter.java` | Critical | Authentication bypass risk | Tech Lead + Security |
| `JwtUtil.java` | Critical | Token validation integrity | Tech Lead + Security |
| `pom.xml` | High | Build and dependency resolution | Developer |
| `ApigatewayApplication.java` | Low | Entry point, rarely changes | Developer |

## How to Safely Propose Changes

### Route Changes (application.yml)

1. Verify the target service name matches Eureka registration exactly
2. Ensure path predicates do not overlap with existing routes
3. Test with `curl` against the gateway to confirm routing
4. Update `docs/API-DOMAINS.md` in the same commit

### Security Changes (JwtAuthFilter.java)

1. Adding public endpoints increases unauthenticated attack surface - justify explicitly
2. Never remove token validation logic without security review
3. Ensure `PUBLIC_ENDPOINTS` list uses `startsWith` matching - be precise with paths
4. Test both positive (valid token) and negative (no token, invalid token) cases

### Dependency Changes (pom.xml)

1. Check Spring Cloud compatibility matrix before upgrading
2. Verify JJWT API/impl/jackson versions stay aligned
3. Run full build and test suite after changes
4. Check for CVEs in new dependency versions

## Coding Conventions

| Convention | Rule |
|-----------|------|
| Package structure | `com.learningplatform.apigateway.<module>` |
| Filter naming | `*Filter.java` suffix for gateway filters |
| Utility naming | `*Util.java` suffix for utility classes |
| Configuration | YAML format, Spring property binding |
| Reactive returns | Always return `Mono<Void>` from filters |
| Error responses | Set status code, call `setComplete()` - no response body from gateway |
| Header naming | `X-` prefix for custom propagated headers |

## Documentation Conventions

| Convention | Rule |
|-----------|------|
| Format | Markdown with proper heading hierarchy |
| Tables | Use for structured comparisons and lists |
| Commands | Must be copy-paste executable |
| Unknowns | Mark as "To Be Confirmed" |
| Cross-references | Link to related docs using relative paths |

## Risk Areas and Guardrails

### High-Risk Changes (Require Extra Caution)

| Area | Risk | Guardrail |
|------|------|-----------|
| `PUBLIC_ENDPOINTS` list | Adding paths exposes unauthenticated access | Require security justification |
| JWT secret (`jwt.secret`) | Exposure compromises all tokens | Never log, never hardcode in non-dev configs |
| Filter order (`getOrder()`) | Changing order may bypass authentication | Keep auth filter at -1 (highest priority) |
| Route predicates | Overlapping paths cause unpredictable routing | Test all routes after changes |
| Dependency scope | Changing `runtime` to `compile` or vice versa | Verify JJWT impl/jackson stay as runtime |

### AI Agent Rules

1. **Never** modify `jwt.secret` value in configuration files
2. **Never** add endpoints to `PUBLIC_ENDPOINTS` without explicit user instruction
3. **Never** change the filter order from -1 without explicit justification
4. **Always** validate YAML syntax after modifying `application.yml`
5. **Always** ensure imports match the actual dependency scope (jjwt-api is compile, jjwt-impl is runtime)
6. **Prefer** adding new routes at the end of the routes list in `application.yml`
7. **Verify** downstream service names match Eureka registration (case-sensitive)

