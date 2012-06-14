#!/bin/sh
cd /usr/src
make buildkernel KERNCONF=DAEMONIK && make installkernel KERNCONF=DAEMONIK
