#!/bin/sh
. "${SELFDIR}/ocjail.subr"

[ $#  -lt 2 ] && usage

jail=$(ocjail_root ${2})
private=$(ocjail_private ${2})

ocjail_ensure_dir ${private}

case "${1}" in
    packages)
        packages=$(echo -e "all:\n\t@echo \$(PACKAGES)\n" | make -f -)
        mountpoint="var/ports/packages"

        [ -d "${private}/${mountpoint}" ] \
        || mkdir -p "${private}/${mountpoint}" \
        || errex

        mount_nullfs -o noatime,ro ${packages} "${jail}/${mountpoint}"
        ;;
    *)
       usage;;
esac
