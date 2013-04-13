#!/bin/sh
. ${SELFDIR}/ocjail.subr
[ $# -lt 1 ] && usage

ZROOT=$(zfs_get_pool ${JAILS})
RCCONF=/etc/rc.conf.local

jail=$(ocjail_root ${1})
private=$(ocjail_private ${1})
fstab=/etc/fstab.${1}
pkgconf=/usr.local/etc/pkg.conf
resolvconf=/etc/resolv.conf
templatefile=${jail}/jailtemplate

if [ -e "${jail}" ]; then
    read base < ${templatefile} || errex "unable to determine ${jail} template."
    template=$(echo $base | sed -e 's/\.jailbase$/\.private/')
else
    base=${JAILS}/${JAILBASE}.jailbase
    template=${JAILS}/${JAILBASE}.private
fi

case "${CMD}" in
    destroy)
        if is_jail_running "${1}"; then
            service jail stop ${1} || errex
        fi

        echo === Destroying filesystem ${private}
        zfs_destroy_clone ${template} ${1} ${private}

        echo === Deleting mountpoints and configuration
        rm -rf ${jail}
        rm     ${fstab}

        echo Please manually remove the jail entry in ${RCCONF}
        ;;
    create)
        if [ ! -e "${private}" ]; then
            echo === Cloning ${template} to ${private}
            zfs_create_clone ${template} ${1} ${private}
        fi

        echo === Creating ${jail} directories
        mkdir -pv ${jail} || errex
        mkdir -pv ${jail}/dev || errex
        mkdir -pv ${jail}/private || errex
        mkdir -pv ${private}/usr.local/etc || errex

        echo === Updating configuration
        echo ${RCCONF}
        echo "jail_list=\"\${jail_list} ${1}\"" >> ${RCCONF} || errex
        echo "jail_${1}_rootdir=\"${jail}\""    >> ${RCCONF} || errex

        echo ${templatefile}
        echo ${base} > ${templatefile}

        if [ ! -e "${fstab}" ]; then
            echo ${fstab}
            echo "${base}        ${jail}         nullfs ro 0 0"  > ${fstab} || errex
            echo "${private}     ${jail}/private nullfs rw 0 0" >> ${fstab} || errex
        fi

        if [ ! -e "${private}${pkgconf}" ]; then
            echo ${private}${pkgconf}
            echo "PACKAGESITE : file:///usr/ports/packages" > ${private}${pkgconf} || errex
        fi

        echo ${private}${resolvconf}
        if [ -e "${resolvconf}" -a ! -e "${private}${resolvconf}" ]; then
            echo ${private}${resolvconf}
            cp -v ${resolvconf} ${private}${resolvconf} || errex
        fi
    ;;
    *) usage;;
esac
