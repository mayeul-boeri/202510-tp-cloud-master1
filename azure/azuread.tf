resource "azuread_group" "admins" {
  display_name    = "Administrateurs Cloud"
  security_enabled = true
}

resource "azuread_group" "devs" {
  display_name    = "Développeurs"
  security_enabled = true
}

resource "azuread_group" "readers" {
  display_name    = "Lecteurs"
  security_enabled = true
}

resource "azuread_user" "user1" {
  user_principal_name = "user1@votre-domaine.onmicrosoft.com"
  display_name        = "User 1"
  password            = "MotDePasseSecurise123!"
}

resource "azuread_user" "user2" {
  user_principal_name = "user2@votre-domaine.onmicrosoft.com"
  display_name        = "User 2"
  password            = "MotDePasseSecurise123!"
}

resource "azuread_group_member" "user1_admin" {
  group_object_id  = azuread_group.admins.id
  member_object_id = azuread_user.user1.id
}

resource "azuread_group_member" "user2_dev" {
  group_object_id  = azuread_group.devs.id
  member_object_id = azuread_user.user2.id
}

