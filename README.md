# Mikrotik The Dude Telegram Notification Bot

This is writted to work with dude 6.x which run on Mikrotik routers


1) Customize notifications in The Dude
  * On the left panel of The Dude go down to "Notifications" and open it.
  * edit the "log to syslog" notification
  * modify the "Text" to: ```Service [Probe.Name] at *[Device.NetMaps]* on [Device.Name] [Device.FirstAddress] is now _[Service.Status]_ `([Service.ProblemDescription])````

2) On the mikrotik hosting the dude you need to send the dude logs to a linux log server
  * /system logging action set 3 remote=192.168.0.1
  * /system logging add action=remote topics=dude

3) On the linux server edit ```/etc/rsyslog.conf```
  * at the bottom add the following
  * `# Save The Dude Events to log`
  * `$template TheDude, "/var/log/dude.log"`
  * `:fromhost-ip, isequal, "192.168.0.2" -?TheDude`
  * `& ~`

4) Save & exit ```/etc/rsyslog.conf``` & restart the rsyslog service

5) Put the bash script onto the same server as the logs

6) You still need to setup a Telegram bot
  * https://core.telegram.org/api#getting-started
  * https://core.telegram.org/bots
  * https://core.telegram.org/bots/api
