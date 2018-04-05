# cyrus-imapd-mboxlist.db-rebuild-script

##Introduction
This script rebuilds the mailboxes.db in /var/lib/imap folder.
It is tested on CentOS 7 with Cyrus-Imapd 2.4
For other OS or cyrus version you might need to modify start/stop calls and paths.

##How to use
Just check out or download the script and run it as root. Thats it
The reconstruct part might take some time, depending on how many mailboxes you have
