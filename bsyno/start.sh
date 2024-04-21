#!/bin/sh

# chmod +x -R /SynoBoot && cd /SynoBoot && ./synomenu.sh install

hdd="/home/container/EGGDsm/bsyno/HDD.qcow2"
imgboot="/home/container/EGGDsm/bsyno/arc-flat.vmdk"
ram=3G
core=2
sizeStockage=2000G

BootSynology() {
    if [ ! -f "$hdd" ]; then
	    echo 'Ajoute d un nouveaux disque dur synology !'
        qemu-img create -f qcow2 ${hdd} ${sizeStockage}
        chmod -R 777 ${hdd}
    fi
	#
    qemu-system-x86_64 -name vm_name,process="SynoB" -nographic -boot order=c \
        -net nic,model=virtio-net-pci \
        -net user,hostfwd=tcp::3002-:7681,hostfwd=tcp::7681-:3002, \
        -machine type=q35 \
        -device qemu-xhci -device usb-tablet \
        -drive file="${imgboot}",index=0,media=disk \
        -drive file="${hdd}",index=1,media=disk
        #-drive file="${dir}/SynologyHDD.qcow2",index=1,media=disk

}
BootSynology 
/bin/bash
