# Restrict the process to the runtime and application paths
private=/var/www
private=/run/php
private=/tmp
read-only=/var/www
read-only=/etc/php
read-only=/etc/php-fpm.conf
read-only=/etc/php-fpm.d

# Reduce attack surface
nosound
novideo
nogroups
net none
# If the worker must communicate with the app or database, allow only required interfaces
# use "net eth0" or "net=none" with explicit proxying if needed

# Filesystem and process controls
noexec /tmp
noexec /var/tmp
noroot
caps.drop all
seccomp
protocol unix,inet,inet6
nonewprivs

# Keep the process under a non-root user
# Example:
# user php
# group php

# Log and runtime paths should be explicit and restricted
whitelist /var/log/php
whitelist /var/run/php
