#!/bin/sh

. ${SELFDIR}/ocjail.subr

[ $# -lt 1 ] && usage

ZROOT=$(zfs_get_pool ${JAILS})
SYSCONFDIR=/etc
RCCONF=${SYSCONFDIR}/rc.conf.local

base=${JAILS}/${JAILBASE}.jailbase
template=${JAILS}/${JAILBASE}.private
snapshot=${template}@${1}

jail=${JAILS}/${1}
private=${JAILS}/${1}.private
fstab=${SYSCONFDIR}/fstab.${1}

if [ -e ${jail} -o -e ${private} ]; then
    errex "jail ${jail} already exists"
fi

echo === Cloning ${template} to ${private}
zfs_create_clone ${template} ${1} ${private}

echo === Creating ${jail}
mkdir ${jail}
mkdir ${jail}/dev

echo === Creating ${fstab}
echo "${base}\t\t${jail}         nullfs ro 0 0"  > ${fstab}
echo "${private}\t\t${jail}/private nullfs rw 0 0" >> ${fstab}

echo === Updating ${RCCONF}
echo "jail_list=\"\${jail_list} ${1}\"" >> ${RCCONF}
echo "jail_${1}_rootdir=\"${jail}\""    >> ${RCCONF}
