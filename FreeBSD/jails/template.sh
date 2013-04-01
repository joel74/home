#!/bin/sh
. "${SELFDIR}/ocjail.subr"

INSTALL_LOG=/tmp/installworld.log
WRITABLE_DIRS='etc root tmp usr/local usr/home var'

SRCCONF=${SELFDIR}/default.src.conf
 SRCDIR=/usr/src
  ZROOT=$(zfs_get_pool ${JAILS})

# converts usr/local/bin to usr.local.bin
make_flat_name() {
    echo $* | sed -e 's/\//./g'
}

# converts usr.local.bin to ../../private/usr.local.bin
make_private_path() {
    echo $* | awk -F. '{
        for(I=1; I<=(NF-1); I++) printf "%s", "../"; print "private/" $0
    }'
}

foreach_writable_dir() {
    local cmd flatname privpath

    cmd=$1

    for dir in ${WRITABLE_DIRS}; do
        flatname="$(make_flat_name ${dir})"
        privpath=`make_private_path ${flatname}`

        ${cmd}
    done
}

mv_to_base() {
    if [ -L "${base}/${dir}" ]; then
        rm "${base}/${dir}"
    fi

    if [ -d "${template}/${flatname}" ]; then
        cp -a "${template}/${flatname}/" "${base}/${dir}" \
        || errex "failed to copy files from ${template}/${flatname} to ${base}/${dir}"

        rm -rf "${template}/${flatname}" \
        || errex "failed to remove ${template}/${flatname}"
    fi
}

mv_to_private() {
    if [ ! -e "${template}/${flatname}" ]; then
        mkdir "${template}/${flatname}" \
        || errex "failed to create ${template}/${flatname}"
    fi

    if [ -L "${base}/${dir}" ]; then
        rm "${base}/${dir}" \
        || errex "failed to remove ${base}/${dir}"
    fi

    if [ -d "${base}/${dir}" ]; then
        cp -a "${base}/${dir}/" "${template}/${flatname}" \
        || errex "failed to move files from ${base}/${dir} to ${template}/${flatname}"

        rm -rf "${base}/${dir}" \
        || errex "failed to remove ${base}/${dir}"
    fi

    ln -s "${privpath}" "${base}/${dir}" \
    || errex "failed to link ${privpath} to ${base}/${dir}"

}

install_world() {
    local temproot
    temproot="${template}/var/tmp/temproot"

    echo Clearing old logs and temp files
    [ -e ${INSTALL_LOG} ]        && rm ${INSTALL_LOG}
    [ -e ${temproot} ]           && rm -rf ${temproot}
    [ -e ${template}/var/empty ] && chflags noschg ${template}/var/empty

    echo Moving writable directories to ${base}
    foreach_writable_dir mv_to_base

    echo Installing world to ${base}
    make -C ${SRCDIR}              \
         installworld              \
         DESTDIR=${base}           \
         SRCCONF=${SRCCONF}        \
         > ${INSTALL_LOG} 2>&1     \
    || errex "installing world failed. see ${INSTALL_LOG}"

    echo Merging config fies
    mergemaster                    \
        -D ${base}                 \
        -t ${temproot}             \
        -m ${SRCDIR}               \
        -i --run-updates=always    \
    || errex "mergemaster failed"

    # must remove schg flag to move the dir
    [ -e ${base}/var/empty ] && chflags noschg ${base}/var/empty

    echo Moving writable directories to ${template}
    foreach_writable_dir mv_to_private

    # put the schg flag back
    chflags schg ${template}/var/empty

    # make required directories
    [ -e ${base}/dev ] || mkdir ${base}/dev
}

base=${JAILS}/${JAILBASE}.jailbase
template=${JAILS}/${JAILBASE}.private
snapshot="before-installworld-$(date '+%Y.%m.%d-%H:%M:%S')"

echo === Creating filesystems
zfs_ensure_dataset ${JAILS}    -o atime=off -o setuid=off
zfs_ensure_dataset ${base}     -o atime=off -o setuid=off
zfs_ensure_dataset ${template} -o atime=off -o setuid=off

echo === Creating snapshot ${snapshot}
zfs_create_snapshot ${base} ${snapshot}
zfs_create_snapshot ${template} ${snapshot}

echo === Installing world
install_world
