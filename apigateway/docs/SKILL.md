# Skills Matrix

## Required Skills by Role

### Developer

| Skill | Proficiency | Context |
|-------|-------------|---------|
| Java 17 | Advanced | Core language, records, sealed classes, pattern matching |
| Spring Boot 3.x | Advanced | Auto-configuration, reactive stack, property binding |
| Spring Cloud Gateway | Intermediate-Advanced | Route configuration, filters, predicates |
| Spring WebFlux / Reactor | Intermediate | Reactive programming model (Mono/Flux) |
| JWT / JJWT | Intermediate | Token structure, HMAC validation, claims extraction |
| Maven | Intermediate | Dependency management, build lifecycle, profiles |
| YAML | Intermediate | Application configuration |
| Git | Intermediate | Branching, rebasing, cherry-picking |
| REST API Design | Intermediate | HTTP methods, status codes, header conventions |
| Microservices Patterns | Intermediate | Service discovery, circuit breaker, API gateway pattern |

### Code Reviewer

| Skill | Proficiency | Context |
|-------|-------------|---------|
| All Developer skills | Intermediate+ | Ability to evaluate implementation correctness |
| Security awareness | Intermediate | Identify auth bypass risks, header injection, secret exposure |
| Reactive patterns | Intermediate | Verify non-blocking code, no blocking calls in filter chain |
| Spring Cloud internals | Intermediate | Understand filter ordering, route matching priority |

### Release Engineer

| Skill | Proficiency | Context |
|-------|-------------|---------|
| Maven build lifecycle | Intermediate | Clean, package, deploy goals |
| Jenkins pipeline | Intermediate | Stage configuration, approvals, parameters |
| Docker | Basic-Intermediate | Image build, registry push |
| Environment management | Intermediate | Property overrides, profile activation |
| Eureka operations | Basic | Service registration verification |

### Production Support

| Skill | Proficiency | Context |
|-------|-------------|---------|
| Log analysis | Intermediate | Spring Boot log format, Logback levels |
| Actuator endpoints | Intermediate | Health, metrics, environment inspection |
| Network troubleshooting | Basic | Port connectivity, DNS resolution |
| JWT debugging | Basic | Decode tokens (jwt.io), verify expiry |
| Circuit breaker concepts | Basic | Understand open/closed/half-open states |

## Tech Stack Proficiency Matrix

| Technology | Developer | Reviewer | Release Eng. | Support |
|-----------|-----------|----------|-------------|---------|
| Java 17 | Advanced | Advanced | Basic | Basic |
| Spring Boot 3.3 | Advanced | Advanced | Intermediate | Basic |
| Spring Cloud Gateway | Advanced | Intermediate | Basic | Basic |
| Reactor/WebFlux | Intermediate | Intermediate | -- | -- |
| JJWT | Intermediate | Intermediate | -- | Basic |
| Resilience4j | Intermediate | Intermediate | Basic | Basic |
| Eureka | Intermediate | Basic | Intermediate | Intermediate |
| Maven | Intermediate | Basic | Advanced | Basic |
| Docker | Basic | -- | Advanced | Intermediate |
| Jenkins | Basic | -- | Advanced | Basic |

## Operational and Debugging Competencies

| Competency | Description |
|------------|-------------|
| Route debugging | Verify path predicates match expected requests |
| Token inspection | Decode JWT, verify claims and expiry |
| Eureka verification | Confirm service registration and instance count |
| Circuit breaker monitoring | Check breaker state via actuator or logs |
| Log correlation | Trace request flow from gateway to downstream service |
| Configuration validation | Verify YAML syntax and property resolution |

## Security and Compliance Awareness

| Area | Expected Knowledge |
|------|-------------------|
| JWT security | Symmetric vs asymmetric signing, secret management |
| Header injection | Risks of trusting client-provided headers |
| Public endpoint risks | Understanding of unauthenticated access surface |
| Secret management | Never commit secrets, use environment variables or vaults |
| Dependency vulnerabilities | Check CVEs, update affected libraries promptly |

## Recommended Learning Path (Onboarding)

| Week | Focus | Resources |
|------|-------|-----------|
| 1 | Java 17 + Spring Boot fundamentals | Spring Boot reference documentation |
| 1 | Project setup, build, and local run | [OPERATIONS-RUNBOOK.md](OPERATIONS-RUNBOOK.md) |
| 2 | Spring Cloud Gateway concepts | Spring Cloud Gateway reference |
| 2 | Reactive programming basics (Mono/Flux) | Project Reactor documentation |
| 3 | JWT authentication and JJWT library | JJWT GitHub, JWT.io |
| 3 | Eureka service discovery | Spring Cloud Netflix documentation |
| 4 | Resilience4j circuit breaker patterns | Resilience4j documentation |
| 4 | Full end-to-end request flow tracing | [ARCHITECTURE.md](ARCHITECTURE.md) |

