#!/bin/bash

# EC2 Deployment Script
# Usage: ./deploy.sh <ec2-user> <ec2-ip>

EC2_USER=$1
EC2_IP=$2

if [ -z "$EC2_USER" ] || [ -z "$EC2_IP" ]; then
    echo "Usage: ./deploy.sh <ec2-user> <ec2-ip>"
    exit 1
fi

echo "Deploying to EC2: $EC2_USER@$EC2_IP"

# Upload JAR files
echo "Uploading Eureka Server JAR..."
scp eureka-server/target/eureka-server-0.0.1-SNAPSHOT.jar $EC2_USER@$EC2_IP:/home/$EC2_USER/

echo "Uploading API Gateway JAR..."
scp apigateway/target/api-gateway-0.0.1-SNAPSHOT.jar $EC2_USER@$EC2_IP:/home/$EC2_USER/

# Create deployment script on EC2
echo "Creating deployment script on EC2..."
ssh $EC2_USER@$EC2_IP << 'EOF'
cat > /home/ec2-user/start-services.sh << 'SCRIPT'
#!/bin/bash

# Get EC2 public IP
EC2_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Set environment variables
export EUREKA_HOSTNAME=$EC2_IP
export EUREKA_PREFER_IP=true
export EUREKA_SERVER_URL="http://$EC2_IP:8761/eureka/"
export JWT_SECRET="your-production-jwt-secret-change-this"

# Stop existing services
pkill -f eureka-server
pkill -f api-gateway

# Start Eureka Server
echo "Starting Eureka Server..."
nohup java -jar -Dspring.profiles.active=prod /home/ec2-user/eureka-server-0.0.1-SNAPSHOT.jar > /home/ec2-user/eureka.log 2>&1 &

# Wait for Eureka to start
sleep 30

# Start API Gateway
echo "Starting API Gateway..."
nohup java -jar -Dspring.profiles.active=prod /home/ec2-user/api-gateway-0.0.1-SNAPSHOT.jar > /home/ec2-user/gateway.log 2>&1 &

echo "Services started. Check logs:"
echo "Eureka: tail -f /home/ec2-user/eureka.log"
echo "Gateway: tail -f /home/ec2-user/gateway.log"
SCRIPT

chmod +x /home/ec2-user/start-services.sh
EOF

echo "Deployment files uploaded successfully!"
echo "SSH into EC2 and run: /home/ec2-user/start-services.sh"
