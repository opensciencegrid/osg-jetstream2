
/usr/sbin/ospool-fix-networking:
  file.managed:
    - source: salt://cloud-init/ospool-fix-networking
    - user: root
    - group: root
    - mode: 755

/etc/cloud/cloud.cfg:
  file.managed:
    - source: salt://cloud-init/cloud.cfg
    - user: root
    - group: root
    - mode: 644

