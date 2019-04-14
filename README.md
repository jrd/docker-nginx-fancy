nginx with fancy index module
=============================

This is the regular nginx docker with the [Fancy Index module](https://www.nginx.com/resources/wiki/modules/fancy_index/) already available and loaded.

Please see the fancy index documentation for configuration.

The default configuration allow listing files in `/usr/share/nginx/html/`.

Actions during entry point
--------------------------

This version also allows to add any `.sh` or `.deb` files to be run/installed if:
* there is any `.sh` file in `/etc/nginx/shell.d/`,
* there is any `.deb` file in `/etc/nginx/pkg.d/`.

These are run before launching nginx binary, so it will be easier to add any other modules if necessary.

Extra configuration
-------------------

Any `.conf` file in `/etc/nginx/load.d/` directory will be included in the main `nginx.conf` file.
An empty `00-empty.conf` file is present by default.

Docker tags
-----------
* `latest`, `1.15`, `1.14`
* `alpine`, `1.15-alpine`, `1.14-alpine`
* `perl`, `1.15-perl`, `1.14-perl`
* `alpine-perl`, `1.15-alpine-perl`, `1.14-alpine-perl`
