# Project Overview

## Business Context

The Online Learning Platform is a microservices-based e-learning system enabling course creation, enrollment, media delivery, and payment processing. The API Gateway serves as the unified entry point, abstracting backend service topology from clients and enforcing cross-cutting concerns centrally.

## Problem Statement

In a distributed microservices architecture, clients should not need knowledge of individual service locations or handle authentication against each service independently. A centralized gateway provides:

- Single network entry point for all API consumers
- Consistent authentication and authorization enforcement
- Dynamic routing via service discovery
- Fault tolerance through circuit breaking
- Simplified client integration

## Key Capabilities

| Capability | Description |
|------------|-------------|
| Request Routing | Path-based routing to downstream microservices via Eureka discovery |
| JWT Authentication | Global filter validates Bearer tokens on all protected routes |
| Identity Propagation | Extracts user ID and role from JWT, forwards as headers to downstream services |
| Circuit Breaking | Resilience4j integration prevents cascading failures |
| Load Balancing | Client-side load balancing via Spring Cloud LoadBalancer |
| Health Monitoring | Actuator endpoints for operational visibility |

## User Roles and Personas

| Role | Interaction with Gateway |
|------|--------------------------|
| Student | Accesses courses, cart, enrollment, and media APIs |
| Instructor | Manages course content and media uploads |
| Admin | Full access to all platform capabilities |
| Anonymous | Limited to public endpoints (login, register, public catalog) |

## Scope

### In-Scope

- JWT validation and claim extraction
- Route definition and service discovery integration
- Public/protected endpoint classification
- Header-based identity propagation to downstream services
- Circuit breaker configuration
- Health and readiness endpoints

### Out-of-Scope

- User authentication (delegated to auth-service)
- Business logic processing (delegated to domain services)
- Rate limiting (not currently implemented)
- API versioning at gateway level
- Request/response transformation

## Functional Lifecycle

```
1. Client sends HTTP request to gateway (port 8080)
2. JwtAuthFilter evaluates if path is public
3. If protected: validates Bearer token, extracts claims
4. Gateway resolves target service via Eureka
5. Request is forwarded with X-User-Id and X-User-Role headers
6. Response is relayed back to client
```

