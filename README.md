# cyrus-imapd-mboxlist.db-rebuild-script

## Introduction
This script rebuilds the mailboxes.db in /var/lib/imap folder.

It is tested on CentOS 7 with Cyrus-Imapd 2.4.

For other OS or cyrus version you might need to modify start/stop calls and paths.

## How to use
Just check out or download the script, then modify line 14 if neccessary. This is the line producing the output for each mailbox. If your cyrus user is cyrus you are fine, if not just change cyrus to whatever your cyrus user is.

Now run it as root. Thats it.

The reconstruct part might take some time, depending on how many mailboxes you have.
