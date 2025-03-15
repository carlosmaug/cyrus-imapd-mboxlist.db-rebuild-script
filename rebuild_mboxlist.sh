#!/bin/bash
generar_cadena_aleatoria() {
  local longitud=24
  local caracteres="abcdefghijklmnopqrstuvwxyz0123456789"
  local cadena=""
  local i

  for ((i=0; i<longitud; i++)); do
    local indice=$((RANDOM % ${#caracteres}))
    cadena+="${caracteres:indice:1}"
  done

  echo "$cadena"
}

echo -e "stopping cyrus..\n"
systemctl stop cyrus-imapd

echo -e "backup mailboxes.db..\n"
mv /var/lib/cyrus/mailboxes.db /var/lib/cyrus/mailboxes.db.$$

echo -e "building new mailboxes.db flat file..\n"
echo "{" > /tmp/mboxflat.txt
find /var/spool/cyrus/mail/?/user -maxdepth 1 -mindepth 1 | \
  while read i; do
    k=$(basename $i|sed 's/user\.//')
    uidvalidity=$((RANDOM * RANDOM))
    uid=$(generar_cadena_aleatoria)
    echo -e "\"user.$k\": {\"name\": \"user.$k\", \"mtime\": \"1718791095\", \"uidvalidity\": \"$uidvalidity\", \"createdmodseq\": \"0\", \"foldermodseq\": \"1\", \"mbtype\": \"el\", \"partition\": \"default\", \"acl\": {\"$k\": \"lrswipcda\", \"cyrus\": \"lrswipcda\"}, \"uniqueid\": \"$uid\", \"name_history\": []}," >> /tmp/mboxflat.txt
  done

sed -i '$s/.$//' /tmp/mboxflat.txt
echo "}" >> /tmp/mboxflat.txt

echo -e "importing mailboxes flat file in new mailboxes.db..\n"
/usr/lib/cyrus/bin/ctl_mboxlist -u </tmp/mboxflat.txt
rm -f /tmp/mboxflat.txt
echo -e "starting reconstruct\n"
/usr/lib/cyrus/bin/reconstruct -V max

find /var/spool/cyrus/mail/?/user -iname cyrus.header | \
  while read i; do
          /usr/lib/cyrus/bin/reconstruct -P "$(echo $i| sed 's/\/cyrus.header//')"
  done

find /var/spool/cyrus/mail/?/user -maxdepth 1 -mindepth 1 | \
  while read i; do
        /usr/lib/cyrus/bin/reconstruct -rf user/$(basename $i)
  done

echo -e "restarting cyrus..\n"
systemctl start cyrus-imapd
