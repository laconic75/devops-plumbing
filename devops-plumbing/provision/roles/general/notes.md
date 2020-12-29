* Update all packages
* If necessary set up proxy
* Upload general environment settings to /etc/environment
* If necessary set DNS servers
* For AWS install aws-cli
* Set timezone
  * If necessary set local ntp servers 
* Mount and format additional volumes
* Add internal CA's
* Set up OS firewall
* Server Hardening
  * Disable weak ssh cyphers with /etc/ssh/sshd_config
  * Disable TCP timestamps with /etc/sysctl.conf
      * Probably not necessary anymore
      * https://security.stackexchange.com/questions/111794/pros-and-cons-of-disabling-tcp-timestamps/224696#224696?newreg=35e61a614b424bc3862cac787e0e5573
