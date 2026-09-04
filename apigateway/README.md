# API Gateway - Online Learning Platform

## Purpose

Centralized API Gateway for the Online Learning Platform microservices ecosystem. This service acts as the single entry point for all client requests, handling JWT-based authentication, request routing, load balancing, and circuit-breaking across downstream services.

## Architecture Summary

```
Client --> [API Gateway :8080] --> Eureka Discovery --> Downstream Services
                |
         JWT Auth Filter
         (Global Filter)
```

The gateway is built on Spring Cloud Gateway (reactive/WebFlux) and integrates with Netflix Eureka for service discovery. All protected routes require a valid JWT Bearer token; authenticated user context is propagated downstream via custom headers.

## Documentation Index

| Document | Description |
|----------|-------------|
| [Project Overview](docs/PROJECT-OVERVIEW.md) | Business context, capabilities, and scope |
| [Architecture](docs/ARCHITECTURE.md) | Runtime architecture, security, and topology |
| [API Domains](docs/API-DOMAINS.md) | Route definitions and endpoint mapping |
| [Release and Upgrade Cycle](docs/RELEASE-UPGRADE-CYCLE.md) | Release lifecycle and upgrade policies |
| [Operations Runbook](docs/OPERATIONS-RUNBOOK.md) | Build, run, deploy, and troubleshoot |
| [Governance](docs/GOVERNANCE.md) | Approval workflows and compliance |
| [Git Workflow](docs/GIT-WORKFLOW.md) | Branching, commits, and merge strategies |
| [Jenkins Pipeline](docs/JENKINS-PIPELINE.md) | CI/CD pipeline stages and configuration |
| [Skills Matrix](docs/SKILL.md) | Required competencies by role |
| [Agentic AI Context](docs/AGENTIC-AI-CONTEXT.md) | AI agent guidance and guardrails |

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Runtime | Java 17 |
| Framework | Spring Boot 3.3.0 |
| Gateway | Spring Cloud Gateway (reactive) |
| Service Discovery | Netflix Eureka Client |
| Auth | JJWT 0.11.5 (HMAC-SHA) |
| Resilience | Resilience4j (Circuit Breaker) |
| Observability | Spring Boot Actuator |
| Build | Maven (Maven Wrapper included) |
| Cloud BOM | Spring Cloud 2023.0.1 |

## Build, Test, Run

```bash
# Build
./mvnw clean package -DskipTests

# Run tests
./mvnw test

# Run locally
./mvnw spring-boot:run

# Run JAR directly
java -jar target/api-gateway-0.0.1-SNAPSHOT.jar
```

## Configuration

| Property | Description | Default |
|----------|-------------|---------|
| `server.port` | Gateway listen port | 8080 |
| `jwt.secret` | HMAC signing key (hex-encoded) | See `application.yml` |
| `eureka.client.service-url.defaultZone` | Eureka server URL | `http://localhost:8761/eureka/` |

Configuration is managed via `src/main/resources/application.yml`. Environment-specific overrides can be applied through Spring profiles or environment variables.

## API Access

All downstream APIs are accessed through the gateway at `http://localhost:8080`. Routes are defined in `application.yml` under `spring.cloud.gateway.routes`. Public endpoints (no auth required):

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/courses/public/**`
- `POST /api/webhooks/payment`

All other endpoints require `Authorization: Bearer <token>` header.

