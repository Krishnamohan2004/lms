# Architecture

## Runtime Architecture

The API Gateway is a Spring Cloud Gateway application running on the reactive (WebFlux/Netty) stack. It does not use servlet containers.

```
                         +------------------+
                         |   API Gateway    |
   Client Request -----> |   (port 8080)    |
                         |                  |
                         | +==============+ |
                         | | JwtAuthFilter| |  (GlobalFilter, order=-1)
                         | +==============+ |
                         |        |         |
                         | +==============+ |
                         | | Route Engine | |  (Path predicates + lb:// URIs)
                         | +==============+ |
                         +--------|---------+
                                  |
                    +-------------+-------------+
                    |             |             |
              +-----------+ +-----------+ +-----------+
              |auth-service| |catalog-svc| |cart-service|  ...
              +-----------+ +-----------+ +-----------+
                    |             |             |
              +-----+-------------+-------------+-----+
              |           Eureka Server               |
              |         (port 8761)                   |
              +---------------------------------------+
```

## Component Responsibilities

| Component | Responsibility |
|-----------|---------------|
| `ApigatewayApplication` | Spring Boot entry point |
| `JwtAuthFilter` | Global filter; authenticates requests, injects identity headers |
| `JwtUtil` | Token parsing, validation, and claim extraction using HMAC-SHA |
| `application.yml` | Route definitions, Eureka config, JWT secret |

## Data Flow

1. Inbound HTTP request arrives at Netty server (port 8080)
2. `JwtAuthFilter` (order -1) executes before all other filters
3. Public endpoints pass through without authentication
4. Protected endpoints require valid `Authorization: Bearer <token>`
5. On valid token: `X-User-Id` and `X-User-Role` headers are injected
6. Spring Cloud Gateway matches route predicates (path-based)
7. LoadBalancer resolves service instance from Eureka registry
8. Request is proxied to the resolved downstream instance
9. Response flows back through the filter chain to the client

## Security Architecture

### Authentication Flow

```
Client --> Authorization: Bearer <JWT> --> Gateway
  |
  v
JwtAuthFilter:
  1. Check if public endpoint --> skip auth
  2. Extract token from header
  3. Validate signature (HMAC-SHA with shared secret)
  4. Extract subject (userId) and role claim
  5. Mutate request with X-User-Id, X-User-Role headers
  6. Forward to downstream service
```

### Key Security Decisions

| Decision | Implementation |
|----------|---------------|
| Algorithm | HMAC-SHA (symmetric key) |
| Token Location | `Authorization` header, Bearer scheme |
| Identity Propagation | Custom headers (`X-User-Id`, `X-User-Role`) |
| Public Endpoints | Whitelist in `JwtAuthFilter.PUBLIC_ENDPOINTS` |
| Token Issuer | External (auth-service) |
| Key Storage | `jwt.secret` property (should be externalized in production) |

### Public Endpoints (No Auth Required)

- `/api/auth/register`
- `/api/auth/login`
- `/api/courses/public/**`
- `/api/webhooks/payment`

## Environment Topology

| Environment | Gateway Port | Eureka URL | Notes |
|-------------|-------------|------------|-------|
| Local Dev | 8080 | `http://localhost:8761/eureka/` | All services on localhost |
| QA | To Be Confirmed | To Be Confirmed | Shared Eureka cluster |
| Production | To Be Confirmed | To Be Confirmed | HA deployment recommended |

## Non-Functional Considerations

### Scalability

- Reactive (non-blocking) stack supports high concurrency on minimal threads
- Stateless design allows horizontal scaling behind a load balancer
- No session state stored in the gateway

### Observability

- Spring Boot Actuator enabled (`/actuator/health`)
- Micrometer metrics available for monitoring integration
- Logging via SLF4J/Logback

### Resilience

- Resilience4j Circuit Breaker integrated via `spring-cloud-starter-circuitbreaker-reactor-resilience4j`
- Prevents cascading failures when downstream services are unavailable
- Circuit breaker configuration: To Be Confirmed (defaults apply)

### Performance

- Netty-based non-blocking I/O
- Client-side load balancing reduces single-point bottlenecks
- No request body buffering at gateway level (pass-through proxy)

