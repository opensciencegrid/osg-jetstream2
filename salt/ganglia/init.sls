

/etc/ganglia/gmond.conf:
  file:
    - managed
    - source:
      - salt://ganglia/gmond.conf
    - user: root
    - group: root
    - mode: 644

ganglia-gmond:
  pkg:
    - installed
  service.running:
    - name: gmond
    - enable: True
    - watch:
      - file: /etc/ganglia/gmond.conf

{% if 'control' in salt['grains.get']('roles', []) %}

/etc/ganglia/gmetad.conf:
  file:
    - managed
    - source:
      - salt://ganglia/gmetad.conf
    - user: root
    - group: root
    - mode: 644

ganglia-gmetad:
  pkg:
    - installed
  service.running:
    - name: gmetad
    - enable: True
    - watch:
      - file: /etc/ganglia/gmetad.conf

/etc/httpd/conf.d/ganglia.conf:
  file:
    - managed
    - source:
      - salt://ganglia/httpd-ganglia.conf
    - user: root
    - group: root
    - mode: 644

httpd:
  service.running:
    - enable: True
    - watch:
      - file: /etc/httpd/conf.d/ganglia.conf

{% endif %}
