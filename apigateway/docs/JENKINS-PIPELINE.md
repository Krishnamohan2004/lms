# Jenkins Pipeline

## Pipeline Overview

The CI/CD pipeline builds, tests, and deploys the API Gateway service. Pipeline configuration is expected as a `Jenkinsfile` in the repository root.

## Pipeline Stages

| Stage | Purpose | Failure Action |
|-------|---------|----------------|
| Checkout | Clone source from Git | Abort pipeline |
| Build | Compile with Maven | Abort pipeline |
| Unit Test | Run `./mvnw test` | Abort pipeline |
| Quality Gate | Code coverage and static analysis | Abort or warn |
| Package | Build JAR artifact | Abort pipeline |
| Docker Build | Build container image (if applicable) | Abort pipeline |
| Deploy to Dev | Auto-deploy to dev environment | Notify team |
| Deploy to QA | Deploy release candidate | Requires QA trigger |
| Deploy to Prod | Deploy approved release | Requires manual approval |

## Parameter Definitions

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `BRANCH` | String | Branch to build | `dev` |
| `DEPLOY_ENV` | Choice | Target environment (dev/qa/prod) | `dev` |
| `SKIP_TESTS` | Boolean | Skip test execution | `false` |
| `VERSION_OVERRIDE` | String | Manual version override | Empty (use POM version) |

## Branch-to-Environment Mapping

| Branch Pattern | Target Environment | Auto-Deploy |
|---------------|-------------------|-------------|
| `dev` | Development | Yes |
| `release/*` | QA | Manual trigger |
| `main` | Production | Manual approval required |
| `feature/*` | None (build only) | No |
| `hotfix/*` | QA then Prod | Manual approval |

## Build and Test

```groovy
stage('Build') {
    steps {
        sh './mvnw clean package -DskipTests'
    }
}

stage('Test') {
    steps {
        sh './mvnw test'
    }
    post {
        always {
            junit 'target/surefire-reports/*.xml'
        }
    }
}
```

## Quality Gates

| Check | Tool | Threshold |
|-------|------|-----------|
| Unit test pass rate | Maven Surefire | 100% |
| Code coverage | JaCoCo (if configured) | To Be Confirmed |
| Dependency vulnerabilities | OWASP Dependency Check | No critical CVEs |
| Static analysis | SonarQube (if configured) | No blockers |

## Artifact Handling

| Artifact | Format | Storage |
|----------|--------|---------|
| JAR | `api-gateway-<version>.jar` | Nexus/Artifactory |
| Docker Image | `api-gateway:<version>` | Container registry |
| Test Reports | XML/HTML | Jenkins workspace |

### Versioning

- SNAPSHOT versions for development builds
- Release versions (no SNAPSHOT) for release branches
- Docker tags match Maven artifact version

## Deployment Strategy

### Development

- Automatic deployment on successful `dev` branch build
- No approval required
- Health check validation post-deploy

### QA

- Triggered manually from release branch build
- Deploys specific versioned artifact
- Integration test suite runs post-deploy

### Production

- Requires explicit manual approval in pipeline
- Two-approver gate (Release Manager + Tech Lead)
- Blue-green or rolling deployment (To Be Confirmed)
- Automated health check validation
- 30-minute observation window

## Rollback Behavior

| Trigger | Action |
|---------|--------|
| Health check fails post-deploy | Automatic rollback to previous version |
| Manual rollback request | Redeploy previous artifact version |
| Error rate exceeds threshold | Alert + manual decision |

### Rollback Command

```bash
# Redeploy previous version
java -jar api-gateway-<previous-version>.jar
```

## Troubleshooting Failed Runs

| Failure | Investigation Steps |
|---------|-------------------|
| Build failure | Check Maven output, verify `pom.xml` dependencies resolve |
| Test failure | Review Surefire reports in Jenkins workspace |
| Deployment failure | Check target environment connectivity, verify Eureka availability |
| Health check timeout | Verify gateway port is accessible, check startup logs |
| Docker build failure | Verify Dockerfile syntax, check base image availability |
| Artifact publish failure | Check Nexus/Artifactory credentials and connectivity |

