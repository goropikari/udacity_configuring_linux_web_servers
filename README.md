# Taking [Configuring Linux Web Servers](https://www.udacity.com/course/configuring-linux-web-servers--ud299) (Udacity) by using Docker.
Instead of vagrant, I use Docker.

https://docs.docker.com/engine/examples/running_ssh_service/

```
docker build -t eg_sshd .
docker run -d -p 2222:22 --cap-add=NET_ADMIN --name linux_server eg_sshd
ssh ubuntu@localhost -p 2222 # password is 'foobar'. root password is 'screencast'.
```

When you encounter an error to change allow/deny setting:
Change `/etc/default/ufw` in `IPV6` to `no`.


## Apache Server
```
sudo service apache2 start
sudo apt-get install libapache2-mod-wsgi
```


Add `WSGIScriptAlias / /var/www/html/myapp.wsgi` before `</VirtualHost>` in `/etc/apache2/sites-enabled/000-default.conf`

```
sudo apache2ctl restart
```

ref: https://askubuntu.com/questions/256013/apache-error-could-not-reliably-determine-the-servers-fully-qualified-domain-n


## Setup PostgreSQL
```
$ sudo apt-get install postgresql
$ sudo /etc/init.d/postgresql start
$ sudo passwd postgres
$ su - postgres
$ createuser --createdb --username=postgres --pwprompt student
$ createdb sample_db --encoding=UTF-8 --lc-collate=C --lc-ctype=C --owner=student --template=template0
$ exit
$ psql -U student -h localhost -d sample_db

sample_db=> CREATE TABLE sampletb (
  id int,
  title varchar(255)
);


sample_db=> insert into sampletb values (1, 'foo');
sample_db=> insert into sampletb values (2, 'bar');

sample_db=> \q
```

Install `psycopg2` to connect postgres with python.
```
sudo apt-get install python-psycopg2
```

Modify `/var/www/html/myapp.wsgi`.
```
import psycopg2

def application(environ, start_response):
    status = '200 OK'
    output = 'Hello Udacity!'
    conn = psycopg2.connect("host=127.0.0.1 port=5432 dbname=sample_db user=student password=student")
    cur = conn.cursor()
    cur.execute("select * from sampletb")
    results = str([row for row in cur])
    output += results

    response_headers = [('Content-type', 'text/plain'), ('Content-Length', str(len(output)))]
    start_response(status, response_headers)

    return [output]
```

Access `localhost:8080`, you can see
```
Hello Udacity![(1, 'foo'), (2, 'bar')]
```

# Reference

- https://qiita.com/iganari/items/1d590e358a029a1776d6
- https://qiita.com/grgrjnjn/items/8ca33b64ea0406e12938
- https://askubuntu.com/questions/664668/ufw-not-working-in-an-lxc-container
