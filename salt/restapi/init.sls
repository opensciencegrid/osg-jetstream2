
/etc/systemd/system/restapi.service:
  file.managed:
    - source: salt://restapi/restapi.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja

restapi:
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/restapi.service

/etc/cron.d/restapi:
  file.managed:
    - source: salt://restapi/restapi.cron
    - user: root
    - group: root
    - mode: 644
    - template: jinja

