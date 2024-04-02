nginx-conf:
  file.managed:
    - name: /etc/nginx/nginx.conf //etc/nginx altına atılmalıdır.
    - source: salt://nginx/files/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: nginx

nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: nginx-conf
