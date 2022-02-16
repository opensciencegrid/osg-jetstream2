
rynge:
  group.present:
    - gid: 1001
  user.present:
    - uid: 1001
    - gid: 1001
    - shell: /bin/bash
    - home: /home/rynge
    - remove_groups: False
    - groups:
      - rynge
      - docker

osg:
  group.present:
    - gid: 2000
  user.present:
    - uid: 2000
    - gid: 2000
    - shell: /bin/bash
    - home: /home/osg
    - remove_groups: False
    - groups:
      - osg
      - docker


