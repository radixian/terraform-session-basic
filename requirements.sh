# Function to check if a command exists and install it if not
check_and_install() {
    local cmd=$l
    local pkg=$2
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed. Installing $pkg.."
        sudo yum install -y $pkg
    else
        echo "$cmd is already installed. "
      fi
# Update package index
sudo yum update -y
# Check and install Terraform
check_and_install terraform terraform
# Check and install AWS CLI
check_and_install aws aws-cli
# Check and install MySQL client
check_and_install mysql mysql
echo "All checks and installations are complete. "
