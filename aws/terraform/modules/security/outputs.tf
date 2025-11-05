output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

output "nacl_id" {
  value = aws_network_acl.private_nacl.id
}
