#!/bin/sh

# chmod +x -R /SynoBoot && cd /SynoBoot && ./synomenu.sh install

hdd="/home/container/EGGDsm/bsyno/hdd3.qcow2"
imgboot="/home/container/EGGDsm/bsyno/arc-dyn.vmdk"
ram=3G
core=$(nproc)
sizeStockage=2000G

BootSynology() {
    if [ ! -f "$hdd" ]; then
	    echo 'Ajoute d un nouveaux disque dur synology !'
        qemu-img create -f qcow2 ${hdd} ${sizeStockage}
        chmod -R 777 ${hdd}
    fi
	#
    qemu-system-x86_64 -name vm_name,process="SynoB" -nographic -enable-kvm -boot order=c \
        -m ${ram} \
        -machine type=q35 \
        -smp ${core} \
        -nic user,hostfwd=tcp:${INTERNAL_IP}:3002-:7681,hostfwd=tcp:${INTERNAL_IP}:3001-:5000 \
        -device qemu-xhci -device usb-tablet \
        -drive file="${imgboot}",index=0,media=disk \
        -drive file="${hdd}",index=1,media=disk
        #-drive file="${dir}/SynologyHDD.qcow2",index=1,media=disk

}
BootSynology 
#> /dev/null 2>&1 & 
/bin/bash
