#!/bin/sh
#

echo -e "stopping cyrus..\n"
systemctl stop cyrus-imapd

echo -e "backup mailboxes.db..\n"
mv /var/lib/imap/mailboxes.db /var/lib/imap/mailboxes.db.$$

echo -e "building new mailboxes.db flat file..\n"
find /var/spool/imap/?/user -maxdepth 1 -mindepth 1 | \
  while read i; do
    k=$(basename $i)
    echo -e "user.$k\tdefault\t$k\tlrswipcda\tcyrus\tlrswipcda" >> /tmp/mboxflat.txt
  done

echo -e "importing mailboxes flat file in new mailboxes.db..\n"
/usr/lib/cyrus-imapd/ctl_mboxlist -u </tmp/newmboxlist.txt
rm -f /tmp/mboxflat.txt
echo -e "starting reconstruct\n"

find /var/spool/imap/?/user -maxdepth 1 -mindepth 1 | \
  while read i; do
        /usr/lib/cyrus-imapd/reconstruct -rf user.$(basename $i)
  done

echo -e "restarting cyrus..\n"
systemctl start cyrus-imapd

