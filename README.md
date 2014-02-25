# mycookbook

## 自家製cookbook

### JSONサンプル(roll)

```json
{
"name": "test_server",
"chef_type": "role",
"json_class": "Chef::Role",
"default_attributes": {
"java": {
"install_flavor": "oracle",
"jdk_version": "7",
"oracle": {
"accept_oracle_download_terms": true
}
},
"osbase": {
"user": "admin",
"group": "admin",
"user_password": "$1$Se9v8lc7$avlgJL5v6goEM3H3TgQmq1", // openssl passwd -1 "admin"
"ssh_key": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA/pqBxPdR8HDwkss7W7gI2rehBOBe3DlmNY/nrl6fe+KMwyJo7QSl0jL6ggMTV1KQ/9jD1PjYicBCVTwL6zngcLgcIge03dTj2X90Np7GLe1ao9jH0dysLL825m+v1gL0DGlHkcIx27WhonzsVypBELlxC8Y2UCpgMQb49aPnQqMcWuk/AqCa/CaVosAGzo4OtVd0wTadS7NaZTX+qtoCgtpVIwKPG9g52+m+Na0z17PNvu5go18M1cOLexgg47esFKrIwRjs3CEpeWRCC09UFi5HVBT5cSeGYvNmrt5Ek0fb2Sg0EEUiePT0FH72PWuEAuul9PkBZ0TiV+erccRZKw== admin@centos63" // for authorized_keys
},
"playframework": {
"user": "play",
"group": "play",
"user_password": "$1$/SM8MF/Q$SEQjHWQ8nLRP4UbFSVDGy1", // openssl passwd -1 "play"
"play_dir": "/usr/local/play",
"version": "1.2.5.3"
},
"mysqldb": {
"database_name": "play",
"database_user": "play",
"database_user_password": "play"
},
"apache": {
"default_site_enabled": true
},
"mysql": {
"server_root_password":   "123456",
"server_repl_password":   "123456",
"server_debian_password": "123456"
}
},
"run_list": [
"recipe[mycookbook]",
"recipe[java]",
"recipe[mysql]",
"recipe[mysql::client]",
"recipe[mysql::server]",
"recipe[mycookbook::mysqldb]",
"recipe[mycookbook::playframework]"
]
}
```

