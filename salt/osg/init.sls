
enable_extras:
  file.replace:
    - name: /etc/yum.repos.d/Rocky-Extras.repo 
    - pattern: '^enabled=[0,1]'
    - repl: 'enabled=1'

enable_power_tools:
  file.replace:
    - name: /etc/yum.repos.d/Rocky-PowerTools.repo
    - pattern: '^enabled=[0,1]'
    - repl: 'enabled=1'

install_osg:
  pkg.installed:
    - sources:
      - osg-release: https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el8-release-latest.rpm
    
osg_packages:
  pkg.installed:
    - pkgs:
      - osg-oasis
      - autofs

/etc/cvmfs/default.local: 
  file.managed:
    - mode: 644
    - source: salt://osg/default.local

/etc/auto.master.d/cvmfs.autofs: 
  file.managed:
    - mode: 644
    - source: salt://osg/cvmfs.autofs

autofs:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/auto.master.d/cvmfs.autofs

