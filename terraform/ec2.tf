# Define the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

# Define a subnet within the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"  # Change this to your desired availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "MySubnet"
  }
}

# Define the security group for the EC2 instance
resource "aws_security_group" "my_security_group" {
  name        = "MySecurityGroup"
  description = "My security group for the EC2 instance"
  vpc_id      = aws_vpc.my_vpc.id

  # Define inbound and outbound rules as needed
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open SSH for all sources (for demonstration purposes)
  }

  # Add more rules as required
}

# Define the EC2 instance
resource "aws_instance" "backend_server" {
  ami           = "ami-0c38efb4f5f15205f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  count         = 1

  # Attach the security group to the instance
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "Server"
  }
}
