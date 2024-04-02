# MySQL kurulumu ve servis yapılandırması:
mysql-server:
  pkg.installed:
    - name: mysql-server
    - refresh: True

mysql-service:
  service.running:
    - name: mysql
    - enable: True
    - watch:
      - pkg: mysql-server

# MySQL veritabanı ve kullanıcı oluşturma:
create-mysql-db-user:
  mysql_database.present:
    - name: {{ pillar['mysql']['database'] }}
    - charset: utf8
    - collate: utf8_general_ci
    - require:
      - service: mysql-service

create-mysql-user:
  mysql_user.present:
    - name: {{ pillar['mysql']['user'] }}
    - host: localhost
    - password: {{ pillar['mysql']['password'] }}
    - require:
      - mysql_database: create-mysql-db-user

grant-mysql-privileges:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: {{ pillar['mysql']['database'] }}.*
    - user: {{ pillar['mysql']['user'] }}
    - host: localhost
    - require:
      - mysql_user: create-mysql-user

# MySQL yedeklemesi için cron:
mysql-backup-cron:
  cron.present:
    - name: "/usr/bin/mysqldump -u root -p{{ pillar['mysql']['root_password'] }} {{ pillar['mysql']['database'] }} > /backup/{{ pillar['mysql']['database'] }}_$(date +\%Y\%m\%d).sql"
    - identifier: mysql_backup
    - user: root
    - minute: 0
    - hour: 2
