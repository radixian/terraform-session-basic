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
# Refer https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_GettingStarted.CreatingConnecting.MySQL.html#CHAP_GettingStarted.Connecting.MySQL:~:text=To%20install%20the%20mysql%20command%2Dline%20client%20from%20MariaDB%20on%20Amazon%20Linux%202023%2C%20run%20the%20following%20command%3A
check_and_install mariadb105 mariadb105
echo "All checks and installations are complete. "
