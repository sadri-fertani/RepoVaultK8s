resource "vault_generic_secret" "mon_secret" {
  path = "secret/data/mon-app"

  data_json = jsonencode({
    data = {
      username = "sadri"
      password = "supersecretinconnu"
    }
  })
}

resource "vault_generic_secret" "mon_secret_db" {
  path = "secret/data/mon-db"

  data_json = jsonencode({
    data = {
      db_user = "admin"
      db_pass = "motdepasse123"
    }
  })
}
