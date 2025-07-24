#!/bin/bash

# === CONFIGURATION ===
STAGE=${1:-dev}
CONFIG_FILE="${STAGE}_config.sh"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Config file '$CONFIG_FILE' not found."
  exit 1
fi

source "$CONFIG_FILE"

# === LAUNCH EC2 ===
echo "🚀 Launching EC2 instance..."

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP" \
  --subnet-id "$SUBNET_ID" \
  --associate-public-ip-address \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=techeazy-deploy}]' \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "✅ Instance launched: $INSTANCE_ID"

# === WAIT FOR PUBLIC IP ===
echo "⏳ Waiting for instance to be running..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "🌐 Instance public IP: $PUBLIC_IP"

# === CONNECT & SETUP ===
echo "🔧 Connecting and setting up..."
ssh -o StrictHostKeyChecking=no -i "$KEY_PATH" ec2-user@$PUBLIC_IP <<EOF
  sudo yum update -y
  sudo yum install -y git java-21-amazon-corretto maven
  git clone https://github.com/techeazy-consulting/techeazy-devops.git
  cd techeazy-devops
  mvn clean package
  sudo nohup java -jar target/techeazy-devops-0.0.1-SNAPSHOT.jar > output.log 2>&1 &
EOF

# === TEST APP ===
sleep 10
echo "🔍 Checking if app is reachable..."
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://$PUBLIC_IP:80)

if [ "$STATUS_CODE" -eq 200 ]; then
  echo "✅ App is reachable on port 80"
else
  echo "❌ App NOT reachable (HTTP $STATUS_CODE)"
fi

# === SHUTDOWN ===
echo "🕒 Waiting $SHUTDOWN_TIME seconds before stopping instance..."
sleep "$SHUTDOWN_TIME"

aws ec2 stop-instances --instance-ids "$INSTANCE_ID"
echo "🛑 Instance stopped: $INSTANCE_ID"
