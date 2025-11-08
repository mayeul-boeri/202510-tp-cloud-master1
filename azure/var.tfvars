project_name = "tp"
location     = "francecentral"
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
    name = "AzureBastionSubnet"
        cidr = "10.1.254.0/26"
        zone = [1]
        type = "bastion"
    }
]

sql_administrator_login = "sqladminuser"
sql_administrator_password = "P@ssw0rd1234!"

#une adresse email valide est requise pour la création de l'utilisateur Azure AD
sql_useradmin_login = "lukas.cristofaro@ynov.com"
sql_useradmin_password = "UserP@ssw0rd1234!"

sql_connection_string = "Server=tcp:sqltp.database.windows.net,1433;Initial Catalog=sqldb-tp-lc;Persist Security Info=False;User ID=sqladminuser;Password=P@ssw0rd1234!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

vmss_username = "azureuser"
vmss_password = "Password123!"



