[DEFAULT]
debug = False
log_dir = /var/log/kolla/cinder
use_forwarded_for = true
use_stderr = False
osapi_volume_workers = 5
volume_name_template = volume-%s
os_region_name = {{ .Values.endpoints.auth.cinder.region_name }}
enabled_backends = {{ .Values.conf.volume_type }}
default_volume_type = {{ .Values.conf.volume_type }}
osapi_volume_listen = 0.0.0.0
osapi_volume_listen_port = {{ .Values.service.publicService.port }}
api_paste_config = /etc/cinder/api-paste.ini
auth_strategy = keystone
transport_url = 
enable_force_upload = True
verify_glance_signatures = disabled
random_select_backend = True

[oslo_messaging_notifications]
transport_url = 
driver = noop

[oslo_middleware]
enable_proxy_headers_parsing = True

[database]
connection =  
connection_recycle_time = 10
max_pool_size = 1
max_retries = -1

[keystone_authtoken]
www_authenticate_uri = 
auth_url = 
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = {{ .Values.endpoints.auth.cinder.username }}
password = 
memcached_servers = 

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp

[privsep_entrypoint]
helper_command = sudo cinder-rootwrap /etc/cinder/rootwrap.conf privsep-helper --config-file /etc/cinder/cinder.conf

[{{ .Values.conf.volume_type }}]
volume_group = {{ .Values.conf.vg_name }}
volume_driver = {{ .Values.conf.volume_driver }}
volume_backend_name = {{ .Values.conf.volume_type }}
target_helper = tgtadm
target_protocol = iscsi