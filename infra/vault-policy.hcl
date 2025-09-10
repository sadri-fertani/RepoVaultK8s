path "secret/metadata/*" {
  capabilities = ["list"]
}

path "secret/data/*" {
  capabilities = ["read", "list", "subscribe"]
  subscribe_event_types = ["*"]
}

path "sys/events/subscribe/kv*" {
  capabilities = ["read"]
}

