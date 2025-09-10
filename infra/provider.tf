provider "vault" {
  address = "http://127.0.0.1:8200"  # ou https si TLS
  token   = var.vault_token
}