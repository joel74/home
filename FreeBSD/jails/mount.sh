#!/bin/sh
. "${SELFDIR}/ocjail.subr"

[ $#  -lt 2 ] && usage

jail=$(ocjail_root ${2})
private=$(ocjail_private ${2})

ocjail_ensure_dir ${private}

case "${1}" in
    packages)
        is_jail_running "${2}" || errex "jail ${2} is not running"

        packages=$(make -V PACKAGES)
        mountpoint="usr/ports/packages"

        [ -d "${private}/${mountpoint}" ] \
        || mkdir -p "${private}/${mountpoint}" \
        || errex

        if [ -z "${packages}" ]; then
            packages=/usr/ports/packages
        fi

        mount_nullfs -o noatime,ro ${packages} "${jail}/${mountpoint}"
        ;;
    *)
       usage;;
esac
