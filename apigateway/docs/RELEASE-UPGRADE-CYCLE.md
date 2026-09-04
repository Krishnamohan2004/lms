# Release and Upgrade Cycle

## Release Lifecycle

### Stages

| Stage | Activity | Gate |
|-------|----------|------|
| Development | Feature branches merged to `dev` | Code review + unit tests pass |
| Release Candidate | Branch `release/YYYY.MM.DD` cut from `dev` | All integration tests pass |
| QA Validation | Deploy RC to QA environment | QA sign-off |
| Production Approval | Change request raised | Release manager + tech lead approval |
| Production Deploy | Deploy approved artifact | Deployment verification checklist |
| Post-Release | Monitor health endpoints, validate routing | 30-minute observation window |

### Release Naming

Format: `release/YYYY.MM.DD` (e.g., `release/2026.07.26`)

Artifact version: Defined in `pom.xml` as `0.0.1-SNAPSHOT` during development. Release builds should use a fixed version (e.g., `1.0.0`).

## Upgrade Cycle

### Dependency Upgrades

| Component | Cycle | Policy |
|-----------|-------|--------|
| Spring Boot | Quarterly | Follow latest patch within minor version |
| Spring Cloud BOM | Aligned with Spring Boot | Match compatibility matrix |
| JJWT | As needed | Upgrade on CVE or feature need |
| Resilience4j | Aligned with Spring Cloud | Managed by BOM |

### Upgrade Process

1. Create feature branch `feature/dependency_upgrade_<component>`
2. Update version in `pom.xml`
3. Run full test suite
4. Validate gateway routing and JWT validation in local environment
5. Deploy to QA for integration testing
6. Merge via standard PR process

## Cycle Activities

### Start of Cycle

- Review dependency security advisories
- Identify planned features and routes
- Confirm Eureka and downstream service compatibility

### Mid-Cycle

- Feature development and integration
- Route configuration changes
- Security policy updates (public endpoint list changes)

### End of Cycle

- Freeze route changes
- Full regression on all route paths
- Cut release branch
- Update documentation

## Deprecation Policy

### Route Deprecation

| Phase | Duration | Action |
|-------|----------|--------|
| Announcement | 2 sprints before removal | Document deprecated route, notify consumers |
| Grace Period | 1 sprint | Log warnings on deprecated route usage |
| Removal | End of grace period | Remove route from `application.yml` |

### API Version Deprecation

Gateway follows n-2 policy for downstream API versions when versioning is implemented at the service level. The gateway will maintain routing to deprecated service versions for a minimum of 2 release cycles after announcement.

## Operational Decision Points

| Decision | Owner | Criteria |
|----------|-------|----------|
| Cut release branch | Tech Lead | All features merged, tests green |
| Deploy to QA | Release Engineer | RC build successful |
| Approve production deploy | Release Manager | QA sign-off received |
| Rollback decision | On-call Engineer | Health check failures or error rate spike |
| Emergency hotfix | Tech Lead | Critical security or availability issue |

