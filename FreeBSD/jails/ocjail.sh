#!/bin/sh

SELFDIR=$(cd -- $(dirname $0) && pwd)

. "${SELFDIR}/ocjail.subr"

SHX=""

while getopts "r:t:x" OPT; do
    case ${OPT} in
        r) JAILS=${OPTARG};;
        t) JAILBASE=${OPTARG};;
        x) SHX="-x";;
        *) usage;;
    esac
done

JAILS=${JAILS-/var/jail}
JAILBASE=${JAILBASE-default}

shift $((OPTIND-1))
[ $# -lt 1 ] && usage

CMD=$1
shift

case ${CMD} in
    new|template|mount)
        exec env JAILS=${JAILS}        \
                 JAILBASE=${JAILBASE}  \
                 SELFDIR=${SELFDIR}    \
                 /bin/sh ${SHX}        \
                 ${SELFDIR}/${CMD}.sh $@
        ;;
    *)  usage
        ;;
esac
