# AzerothCore-Linux-Helperschripts

before using, read, understand and set the paths, user and password for your environment.
wow_update.sh is an automatic script for updating ac, ac modules, compiling, db backup, db update and starting the server. server.sh starts ac in a separate screen session and is called by wow_update.sh. i have this in combination with two cronjobs which updates ac on wednesday and friday. after that, another cron will send me the compiling and server logs via mail. (not shared here. you have to configure e.g. ssmtp for this. is easy)

cron example:
0 18 * * 5 /path/to/wow_update.sh
it is: execute every friday at 6 pm
