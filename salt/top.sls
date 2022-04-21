base:

  '*':
    - salt
    - base-os
    - cloud-init
    - tmpwatch
    - users
    - osg
    - docker
    - ganglia

  'roles:control':
    - match: grain
    - restapi

  'roles:frontier-squid':
    - match: grain
    - frontier-squid

  'roles:worker':
    - match: grain
    - osgvo-docker-pilot
    - tools

