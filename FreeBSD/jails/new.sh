#!/bin/sh

. ${SELFDIR}/ocjail.subr

[ $# -lt 1 ] && usage

ZROOT=$(zfs_get_pool ${JAILS})
RCCONF=/etc/rc.conf.local

base=${JAILS}/${JAILBASE}.jailbase
template=${JAILS}/${JAILBASE}.private

jail=$(ocjail_root ${1})
private=$(ocjail_private ${1})
fstab=/etc/fstab.${1}
pkgconf=/usr/local/etc/pkg.conf
resolvconf=/etc/resolv.conf

[ -e "${jail}"    ] && errex "directory ${jail} already exists"
[ -e "${private}" ] && errex "directory ${private} already exists"
[ -e "${fstab}"   ] && errex "file ${fstab} already exists"

echo === Cloning ${template} to ${private}
zfs_create_clone ${template} ${1} ${private}

echo === Creating ${jail} directories
mkdir -v  ${jail}
mkdir -v  ${jail}/dev
mkdir -v  ${jail}/private
mkdir -pv ${private}/usr/local/etc

echo === Updating configuration
echo ${fstab}
echo "${base}        ${jail}         nullfs ro 0 0"  > ${fstab}
echo "${private}     ${jail}/private nullfs rw 0 0" >> ${fstab}

echo ${RCCONF}
echo "jail_list=\"\${jail_list} ${1}\"" >> ${RCCONF}
echo "jail_${1}_rootdir=\"${jail}\""    >> ${RCCONF}

echo ${private}${pkgconf}
echo "PACKAGESITE : file:///var/ports/packages" > ${private}${pkgconf}

echo ${private}${resolvconf}
[ -e "${resolvconf}" ] && cp ${resolvconf} ${private}${resolvconf}
