
/tmp/osgvo-token.txt:
  file.managed:
    - contents: {{ pillar['ospool_token'] }}
    - user: root
    - group: root
    - mode: 600

/usr/sbin/osgvo-check-shutdown:
  file.managed:
    - source: salt://osgvo-docker-pilot/osgvo-check-shutdown
    - user: root
    - group: root
    - mode: 755

/etc/cron.d/osgvo-docker-pilot:
  file.managed:
    - source: salt://osgvo-docker-pilot/osgvo-docker-pilot.cron
    - user: root
    - group: root
    - mode: 644

/usr/bin/run-osgvo-docker-pilot-container:
  file.managed:
    - source: salt://osgvo-docker-pilot/run-osgvo-docker-pilot-container
    - user: root
    - group: root
    - mode: 755

/etc/systemd/system/osgvo-docker-pilot.service:
  file.managed:
    - source: salt://osgvo-docker-pilot/osgvo-docker-pilot.service
    - user: root
    - group: root
    - mode: 644

osgvo-docker-pilot:
  service.running:
    - enable: False
    - watch:
      - file: /etc/systemd/system/osgvo-docker-pilot.service

