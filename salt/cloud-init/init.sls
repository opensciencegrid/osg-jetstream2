
/etc/cloud/cloud.cfg:
  file.managed:
    - source: salt://cloud-init/cloud.cfg
    - user: root
    - group: root
    - mode: 644

