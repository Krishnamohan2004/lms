# API Domains

## Overview

The API Gateway does not implement business logic. It routes requests to downstream microservices based on URL path predicates. All APIs are accessed through the gateway at the base URL `http://<gateway-host>:8080`.

## Route Definitions

| Route ID | Target Service | Path Predicates | Discovery URI |
|----------|---------------|-----------------|---------------|
| auth-service | auth-service | `/api/auth/**` | `lb://auth-service` |
| catalog-service | catalog-service | `/api/courses/**`, `/api/categories/**` | `lb://catalog-service` |
| cart-service | cart-service | `/api/cart/**` | `lb://cart-service` |
| order-service | order-payment-service | `/api/orders/**`, `/api/checkout/**` | `lb://order-payment-service` |
| enrollment-service | enrollment-service | `/api/my-courses/**`, `/api/enrollments/**` | `lb://enrollment-service` |
| media-service | media-service | `/api/media/**` | `lb://media-service` |

## Domain Breakdown

### Authentication Domain

| Endpoint Pattern | Auth Required | Description |
|-----------------|---------------|-------------|
| `POST /api/auth/register` | No | User registration |
| `POST /api/auth/login` | No | User login, returns JWT |
| `/api/auth/**` (other) | Yes | Profile, password change, etc. |

### Catalog Domain

| Endpoint Pattern | Auth Required | Description |
|-----------------|---------------|-------------|
| `GET /api/courses/public/**` | No | Public course browsing |
| `/api/courses/**` (other) | Yes | Course CRUD operations |
| `/api/categories/**` | Yes | Category management |

### Cart Domain

| Endpoint Pattern | Auth Required | Description |
|-----------------|---------------|-------------|
| `/api/cart/**` | Yes | Cart add/remove/view operations |

### Order and Payment Domain

| Endpoint Pattern | Auth Required | Description |
|-----------------|---------------|-------------|
| `/api/orders/**` | Yes | Order history and details |
| `/api/checkout/**` | Yes | Checkout and payment initiation |
| `POST /api/webhooks/payment` | No | Payment provider callback |

### Enrollment Domain

| Endpoint Pattern | Auth Required | Description |
|-----------------|---------------|-------------|
| `/api/my-courses/**` | Yes | Student enrolled courses |
| `/api/enrollments/**` | Yes | Enrollment management |

### Media Domain

| Endpoint Pattern | Auth Required | Description |
|-----------------|---------------|-------------|
| `/api/media/**` | Yes | Media upload and streaming |

## Request Patterns

### Authentication Header

All protected endpoints require:

```
Authorization: Bearer <jwt-token>
```

### Propagated Headers (Downstream)

After successful authentication, the gateway injects:

| Header | Source | Description |
|--------|--------|-------------|
| `X-User-Id` | JWT `sub` claim | Authenticated user identifier |
| `X-User-Role` | JWT `role` claim | User role (e.g., STUDENT, INSTRUCTOR, ADMIN) |

## Error Handling

| Scenario | HTTP Status | Response |
|----------|-------------|----------|
| Missing Authorization header | 401 Unauthorized | Empty body, connection closed |
| Invalid/expired JWT | 401 Unauthorized | Empty body, connection closed |
| Service not found in Eureka | 503 Service Unavailable | Gateway error |
| Downstream service timeout | 504 Gateway Timeout | Gateway error |
| Route not matched | 404 Not Found | Default Spring response |

## Versioning and Base Path

- **Base path**: No global prefix; each service defines its own under `/api/<domain>`
- **Versioning**: Not implemented at gateway level; downstream services manage versioning independently
- **Content type**: Pass-through; gateway does not enforce or transform content types

