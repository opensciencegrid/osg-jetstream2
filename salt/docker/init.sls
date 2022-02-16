
/etc/cron.d/docker-maintain:
  file.managed:
    - source: salt://docker/docker-maintain.cron
    - user: root
    - group: root
    - mode: 644
    - template: jinja


