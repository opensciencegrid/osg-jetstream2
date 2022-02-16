/etc/systemd/system/frontier-squid.service:
  file.managed:
    - source:
      - salt://frontier-squid/frontier-squid.service

frontier-squid:
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/frontier-squid.service

