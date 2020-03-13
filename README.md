# lapi
> **L**inux **A**pache **P**HP7 **I**mageMagick

Docker 及び docker-compose をインストールし、本フォルダ内で端末を開き下記コードを実行すると、上記環境が構築されドキュメントルートとなります。

```
docker-compose up --build
```

## 設定例

### 000-default.conf
```
ErrorLog /tmp/error.log
CustomLog /tmp/access.log combined
```

### apache2.conf
```
ErrorLog /tmp/error.log
ServerName localhost
```

### dir.conf
```
<IfModule mod_dir.c>
    DirectoryIndex index.html index.php
</IfModule>
```

### openssl.cnf
```
[system_default_sect]
#MinProtocol = TLSv1.2
#CipherString = DEFAULT@SECLEVEL=2
MinProtocol = None
CipherString = DEFAULT
```

### sysctl.conf
```
net.core.netdev_max_backlog=65536
net.core.rmem_max=33554432
net.core.somaxconn=65536
net.core.wmem_max=33554432
net.ipv4.conf.default.accept_source_route=0
net.ipv4.conf.eth180.arp_announce=2
net.ipv4.conf.eth180.arp_ignore=1
net.ipv4.tcp_fin_timeout=5
net.ipv4.tcp_max_syn_backlog=65536
net.ipv4.tcp_max_tw_buckets=65536
net.ipv4.tcp_rmem=4096 262144 33554432
net.ipv4.tcp_wmem=4096 262144 33554432
```

### /etc/msmtprc
```
account default
auth on
tls on
host xxx.xxx.com
port 587
from xxx@xxx.xxx.com
user xxx@xxx.xxx.com
password ******
```
