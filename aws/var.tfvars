aws_region = "us-east-1"
aws_region_dr = "us-west-2"
project = "tp"
vpc_cidr = "10.0.0.0/16"
subnets = [
    {
        name = "Public-1A"
        cidr = "10.0.1.0/24"
        zone = "us-east-1a"
        type = "public"
    },
    {
        name = "Public-1B"
        cidr = "10.0.2.0/24"
        zone = "us-east-1b"
        type = "public"
    },
    {
        name = "Private-1A"
        cidr = "10.0.10.0/24"
        zone = "us-east-1a"
        type = "private"
    },
    {
        name = "Private-1B"
        cidr = "10.0.11.0/24"
        zone = "us-east-1b"
        type = "private"
    }
]

nat_gateway_subnet_name = "Public-1A"

ec2_username = "user"
ec2_password = "Password123"

#a changer a chaque deployment pour eviter les conflits de nom
rds_secret_name = "tp-rds-credentials4"