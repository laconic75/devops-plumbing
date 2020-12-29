* Install Apache or nginx
* selinux httpd_can_network_connect
* update httpd.conf to redirect to 443
* update ssl.conf with reverse proxy and certificates
* harden ssl.conf with secure cyphers
  * https://ssl-config.mozilla.org/#server=apache&version=2.4.41&config=intermediate&openssl=1.1.1d&guideline=5.6
* Download and install Server certificates and certificate chain
* Set OS firewall settings
