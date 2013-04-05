#!/bin/sh

. ${SELFDIR}/ocjail.subr

[ $# -lt 1 ] && usage

ZROOT=$(zfs_get_pool ${JAILS})
SYSCONFDIR=/etc
RCCONF=${SYSCONFDIR}/rc.conf.local

base=${JAILS}/${JAILBASE}.jailbase
template=${JAILS}/${JAILBASE}.private

jail=$(ocjail_root ${1})
private=$(ocjail_private ${1})
fstab=${SYSCONFDIR}/fstab.${1}

[ -e "${jail}"    ] && errex "directory ${jail} already exists"
[ -e "${private}" ] && errex "directory ${private} already exists"
[ -e "${fstab}"   ] && errex "file ${fstab} already exists"

echo === Cloning ${template} to ${private}
zfs_create_clone ${template} ${1} ${private}

echo === Creating ${jail} mountpoints
mkdir ${jail}
mkdir ${jail}/dev
mkdir ${jail}/private

echo === Creating ${fstab}
echo "${base}        ${jail}         nullfs ro 0 0"  > ${fstab}
echo "${private}     ${jail}/private nullfs rw 0 0" >> ${fstab}

echo === Updating ${RCCONF}
echo "jail_list=\"\${jail_list} ${1}\"" >> ${RCCONF}
echo "jail_${1}_rootdir=\"${jail}\""    >> ${RCCONF}
