resource "vault_kv_secret_v2" "mon_secret_app" {
  mount = "secret"
  name  = "mon-app"

  data_json = jsonencode({
    app_user = "user01-new-05"
    app_pass = "pass01-new-05"
  })
}


resource "vault_kv_secret_v2" "mon_secret_db" {
  mount = "secret"
  name  = "mon-db"

  data_json = jsonencode({
    db_user = "admin-new-05"
    db_pass = "motdepasse123-new-05"
  })
}

