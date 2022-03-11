[DEFAULT]
debug = False
transport_url = 
log_file = /var/log/kolla/keystone/keystone.log
use_stderr = True

[oslo_middleware]
enable_proxy_headers_parsing = True

[database]
connection = 
connection_recycle_time = 10
max_pool_size = 1
max_retries = -1

[token]
revoke_by_id = False
provider = fernet
expiration = 86400
allow_expired_window = 172800

[fernet_tokens]
max_active_keys = 3

[cache]
backend = oslo_cache.memcache_pool
enabled = True
memcache_servers = 

[oslo_messaging_notifications]
transport_url = 
driver = messagingv2
topics = barbican_notifications
