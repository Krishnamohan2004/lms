# Governance

## Ownership

| Role | Responsibility |
|------|---------------|
| Tech Lead | Architecture decisions, route additions, security policy |
| Development Team | Implementation, testing, documentation updates |
| Release Manager | Production deployment approval |
| Security Team | JWT secret rotation, security review |

## Approval Workflow

### Code Changes

```
Developer --> Pull Request --> Code Review (1 approver min) --> Merge to dev
```

### Route Changes

Adding or modifying routes in `application.yml` requires:

1. Pull request with clear description of routing change
2. Confirmation that downstream service is registered and healthy
3. Approval from Tech Lead
4. Integration test evidence

### Security Changes

Changes to `JwtAuthFilter` (especially `PUBLIC_ENDPOINTS`) require:

1. Security review justification
2. Tech Lead approval
3. Documentation update in [API-DOMAINS.md](API-DOMAINS.md)

## Change Management Controls

| Change Type | Approval Required | Documentation Required |
|-------------|-------------------|----------------------|
| New route addition | Tech Lead | Update API-DOMAINS.md |
| Public endpoint addition | Tech Lead + Security | Update API-DOMAINS.md, ARCHITECTURE.md |
| Dependency upgrade | Tech Lead | Update README.md tech stack |
| JWT secret rotation | Security Team | Operations communication |
| Configuration change | Code review | Update OPERATIONS-RUNBOOK.md |

## Traceability and Audit

- All changes tracked via Git history
- Pull requests serve as change records with rationale
- Release branches provide point-in-time snapshots
- Artifact versions map to specific Git commits

### Audit Trail Requirements

| Artifact | Retention | Location |
|----------|-----------|----------|
| Git history | Indefinite | Repository |
| PR reviews | Indefinite | Git platform |
| Build logs | 90 days minimum | CI/CD system |
| Deployment records | 1 year minimum | Deployment platform |

## Documentation Update Policy

Documentation must be updated in the same PR as the code change when:

- A new route is added or removed
- Public endpoint list is modified
- Configuration properties are added or changed
- Dependencies are added or upgraded
- Architecture decisions are made

## Security and Compliance Checkpoints

| Checkpoint | Frequency | Owner |
|------------|-----------|-------|
| Dependency vulnerability scan | Every build | CI pipeline |
| JWT secret rotation | Quarterly | Security Team |
| Public endpoint audit | Each release | Tech Lead |
| Access pattern review | Monthly | Security Team |
| Configuration drift check | Each deployment | Release Engineer |

