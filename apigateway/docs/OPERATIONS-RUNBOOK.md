# Operations Runbook

## Prerequisites

| Requirement | Version | Purpose |
|-------------|---------|---------|
| Java JDK | 17+ | Compile and run |
| Maven | 3.8+ (or use included `mvnw`) | Build tool |
| Eureka Server | Running on port 8761 | Service discovery |
| Git | 2.30+ | Source control |

## Build

```bash
# Clean build (skip tests for speed)
./mvnw clean package -DskipTests

# Full build with tests
./mvnw clean package

# Windows (use mvnw.cmd)
mvnw.cmd clean package
```

Output artifact: `target/api-gateway-0.0.1-SNAPSHOT.jar`

## Run Locally

### Option 1: Maven

```bash
./mvnw spring-boot:run
```

### Option 2: JAR

```bash
java -jar target/api-gateway-0.0.1-SNAPSHOT.jar
```

### Option 3: With Profile Override

```bash
java -jar target/api-gateway-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev
```

### Verify Startup

```bash
curl http://localhost:8080/actuator/health
# Expected: {"status":"UP"}
```

## Environment Variables

| Variable | Description | Override Example |
|----------|-------------|-----------------|
| `SERVER_PORT` | Gateway listen port | `--server.port=9090` |
| `JWT_SECRET` | HMAC signing key | `--jwt.secret=<hex-key>` |
| `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE` | Eureka URL | `--eureka.client.service-url.defaultZone=http://eureka:8761/eureka/` |

## Configuration Files

| File | Purpose |
|------|---------|
| `src/main/resources/application.yml` | Main configuration (routes, eureka, jwt) |

## Health and Readiness

| Endpoint | Purpose |
|----------|---------|
| `GET /actuator/health` | Application health status |
| `GET /actuator` | Available actuator endpoints |

## Troubleshooting

### Common Failure Patterns

| Symptom | Likely Cause | Resolution |
|---------|-------------|------------|
| `Connection refused` on startup | Eureka server not running | Start Eureka server on port 8761 |
| 401 on all requests | JWT secret mismatch between gateway and auth-service | Verify `jwt.secret` matches across services |
| 503 on routed request | Downstream service not registered in Eureka | Verify service is running and registered |
| `RouteDefinitionLocator` bean error | Auto-configuration exclusion issue | Ensure `GatewayAutoConfiguration` is NOT excluded |
| Port already in use | Another process on 8080 | Kill process or change `server.port` |
| Token validation fails | Clock skew or expired token | Check server time synchronization |

### Diagnostic Commands

```bash
# Check if gateway is up
curl -s http://localhost:8080/actuator/health | jq .

# Check Eureka registration
curl -s http://localhost:8761/eureka/apps | grep api-gateway

# Test a protected endpoint without token (expect 401)
curl -v http://localhost:8080/api/cart/items

# Test with valid token
curl -H "Authorization: Bearer <token>" http://localhost:8080/api/cart/items
```

## Production Support Checklist

- [ ] Gateway health endpoint returns `UP`
- [ ] All downstream services registered in Eureka
- [ ] JWT secret is externalized (not in source control for production)
- [ ] Actuator endpoints restricted in production
- [ ] Circuit breaker thresholds configured appropriately
- [ ] Log level set to `INFO` or `WARN` for production

## Rollback Procedure

1. Identify the last known good artifact version
2. Stop current gateway instance
3. Deploy previous JAR version
4. Verify health endpoint: `GET /actuator/health`
5. Validate routing to at least one downstream service
6. Monitor logs for 15 minutes post-rollback

## Incident Quick Actions

| Severity | Action |
|----------|--------|
| Gateway unresponsive | Restart service, check JVM memory |
| All routes returning 503 | Check Eureka connectivity, verify downstream services |
| Authentication failures spike | Verify JWT secret, check token issuer (auth-service) |
| High latency | Check circuit breaker state, review downstream health |

