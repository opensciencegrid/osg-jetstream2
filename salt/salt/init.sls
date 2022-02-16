
{% if 'control' in salt['grains.get']('roles', []) %}

/etc/salt/master.d/master.conf:
  file.managed:
    - source: salt://salt/master.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

salt-master:
  service.running:
    - enable: True
    - watch:
      - file: /etc/salt/master.d/master.conf

{% endif %}

/etc/salt/minion.d/minion.conf:
  file.managed:
    - source: salt://salt/minion.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

salt-minion:
  service.running:
    - enable: True
    - watch:
      - file: /etc/salt/minion.d/minion.conf

/etc/cron.d/salt:
  file.managed:
    - source: salt://salt/salt.cron
    - user: root
    - group: root
    - mode: 644
    - template: jinja


