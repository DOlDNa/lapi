# lapi
> **L**inux **A**pache **P**HP8 **I**mageMagick

Docker 及び docker-compose をインストールし、本フォルダ内で端末を開いて下記コードを実行すると、上記環境が構築されドキュメントルートとなります。

```
docker-compose build
```

## 設定例
lapi でメールを送信するには、msmtprc をテキストファイルで作成する必要があります。
以下を参考に、送信時に使用するメールサーバーのアドレス等を記述して、本フォルダ内に保存し、compose.yaml のコメントアウトを外して下さい。

### msmtprc
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

### compose.yaml
```
    volumes:
      - ".:/var/www/html"
      - "/tmp:/tmp"
      - "/var/tmp:/var/tmp"
#      - "./msmtprc:/etc/msmtprc"
#↑このコメントアウトを削除します
```
