# === CONFIG for DEV Stage ===
AMI_ID="ami-0abcdef1234567890"        # Replace with Amazon Linux 2 AMI for your region
INSTANCE_TYPE="t2.micro"
KEY_NAME="techeazy-key"               # Name of your key pair in AWS
KEY_PATH="/path/to/techeazy-key.pem"  # Full path to your downloaded PEM file
SECURITY_GROUP="sg-0123abc456def7890" # Your security group ID
SUBNET_ID="subnet-0123456789abcdef0"  # Your subnet ID
SHUTDOWN_TIME=60                      # Time (seconds) to wait before stopping instance

