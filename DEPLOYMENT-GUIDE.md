# EC2 Deployment Guide

## Prerequisites
- AWS EC2 instance with Java 17+ installed
- Security groups configured to allow ports 8761 (Eureka) and 8080 (API Gateway)
- SSH access to EC2 instance

## Configuration Changes Made

### 1. Environment Variables Support
Both services now support environment variables for production deployment:

**Eureka Server:**
- `EUREKA_HOSTNAME` - EC2 instance hostname/IP (default: localhost)
- `EUREKA_PREFER_IP` - Use IP address instead of hostname (default: true)

**API Gateway:**
- `EUREKA_SERVER_URL` - Eureka server URL (default: http://localhost:8761/eureka/)
- `EUREKA_HOSTNAME` - EC2 instance hostname/IP (default: localhost)
- `EUREKA_PREFER_IP` - Use IP address instead of hostname (default: true)
- `JWT_SECRET` - JWT signing secret (required for production)

### 2. Production Profiles
Created `application-prod.yml` files with production optimizations:
- Eureka self-preservation disabled
- Optimized registry fetch intervals
- Health check endpoints exposed
- Better lease renewal settings

## Deployment Steps

### 1. Upload JAR Files to EC2
```bash
# Upload Eureka Server JAR
scp eureka-server/target/eureka-server-0.0.1-SNAPSHOT.jar ec2-user@your-ec2-ip:/home/ec2-user/

# Upload API Gateway JAR
scp apigateway/target/api-gateway-0.0.1-SNAPSHOT.jar ec2-user@your-ec2-ip:/home/ec2-user/
```

### 2. Set Environment Variables on EC2
```bash
# SSH into EC2
ssh ec2-user@your-ec2-ip

# Set environment variables (add to ~/.bashrc or ~/.bash_profile)
export EUREKA_HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
export EUREKA_PREFER_IP=true
export EUREKA_SERVER_URL="http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8761/eureka/"
export JWT_SECRET="your-production-jwt-secret-here"
```

### 3. Start Eureka Server
```bash
# Start Eureka Server with production profile
java -jar -Dspring.profiles.active=prod eureka-server-0.0.1-SNAPSHOT.jar

# Or run in background
nohup java -jar -Dspring.profiles.active=prod eureka-server-0.0.1-SNAPSHOT.jar > eureka.log 2>&1 &
```

### 4. Start API Gateway
```bash
# Start API Gateway with production profile
java -jar -Dspring.profiles.active=prod api-gateway-0.0.1-SNAPSHOT.jar

# Or run in background
nohup java -jar -Dspring.profiles.active=prod api-gateway-0.0.1-SNAPSHOT.jar > gateway.log 2>&1 &
```

### 5. Verify Deployment
```bash
# Check Eureka Server
curl http://your-ec2-ip:8761

# Check API Gateway
curl http://your-ec2-ip:8080
```

## Security Group Configuration
Ensure your EC2 security group allows inbound traffic on:
- Port 8761 (Eureka Server)
- Port 8080 (API Gateway)
- Port 22 (SSH for management)

## Process Management (Optional)
For production, consider using systemd or supervisor to manage the services:

### Systemd Service Example
Create `/etc/systemd/system/eureka-server.service`:
```ini
[Unit]
Description=Eureka Server
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user
Environment="EUREKA_HOSTNAME=<your-ec2-ip>"
Environment="EUREKA_PREFER_IP=true"
ExecStart=/usr/bin/java -jar -Dspring.profiles.active=prod /home/ec2-user/eureka-server-0.0.1-SNAPSHOT.jar
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable eureka-server
sudo systemctl start eureka-server
```

## Monitoring
- Check logs: `tail -f eureka.log` or `tail -f gateway.log`
- Monitor processes: `ps aux | grep java`
- Check service status: `sudo systemctl status eureka-server` (if using systemd)

## Troubleshooting
1. **Services not starting**: Check Java version (`java -version`) and ensure it's 17+
2. **Connection refused**: Verify security group settings and firewall rules
3. **Eureka registration fails**: Ensure EUREKA_SERVER_URL is correctly set to the EC2 public IP
4. **Memory issues**: Increase JVM memory with `-Xmx512m -Xms512m` flags
