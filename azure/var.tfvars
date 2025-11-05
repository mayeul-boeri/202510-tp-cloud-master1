project_name = "tp"
location     = "central-europe"
vnet_cidr = "10.1.0.0/16"
subnets = [ 
    {
        name = "frontend"
        cidr = "10.1.1.0/24"
        zone = [1]
        type = "public"
    },
    {
        name = "backend"
        cidr = "10.1.2.0/24"
        zone = [1, 2]
        type = "private"
    },
    {
        name = "database"
        cidr = "10.1.3.0/24"
        zone = [1, 2]
        type = "private"
    },
    {
        name = "azurebastionsubnet"
        cidr = "10.1.254.0/26"
        zone = [1]
        type = "bastion"
    }
]
