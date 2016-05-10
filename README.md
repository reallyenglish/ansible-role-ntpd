ansible-role-ntpd
=====================

Configure NTP daemon

Requirements
------------

None

Role Variables
--------------

| Variable | Description | Default |
|----------|-------------|---------|
| ntpd\_service | service name | ntpd |
| ntpd\_conf | path to ntp.conf | {{ \_\_ntpd\_conf }} |
| ntpd\_db\_dir | dir to place ntpd.leap-seconds.list | /var/db |
| ntpd\_leapfile | path to ntpd.leap-seconds.list | {{ ntpd\_db\_dir }}/ntpd.leap-seconds.list |
| ntpd\_role | NTP client or server (server is not implemented) | client |
| ntpd\_upstreams | a list of upstream | ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org", "3.pool.ntp.org"] |

### FreeBSD

| Variable | Default |
|----------|---------|
| \_\_ntpd\_conf | /etc/ntp.conf |

Dependencies
------------

None

Example Playbook
----------------

        - hosts: localhost
          roles:
            - ansible-role-ntpd

License
-------

BSD

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
