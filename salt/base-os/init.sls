
# keep the cluster lean
base-os.remove-packages:
  pkg.removed:
    - pkgs:
      - avahi
      - cups
      - dnf-automatic
      - firewalld
      - pulseaudio
      - smartmontools

/etc/selinux/config:
  file.managed:
    - source: salt://base-os/selinux-config
    - user: root
    - group: root
    - mode: 644

/etc/sysctl.d/70-ipv6.conf:
  file.managed:
    - source: salt://base-os/70-ipv6.conf
    - user: root
    - group: root
    - mode: 644

/etc/hosts:
  file.managed:
    - source: salt://base-os/hosts
    - user: root
    - group: root
    - mode: 644

