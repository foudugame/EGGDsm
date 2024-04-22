#!/bin/sh

# chmod +x -R /SynoBoot && cd /SynoBoot && ./synomenu.sh install

dir="/home/container"
hdd="${dir}/HDD2.qcow2"
imgboot="${dir}/arc-flat.vmdk"
ram=6G
core=6
sizeStockage=2000G

    echo "https://github.com/AuxXxilium/arc/releases/download/"

    if [ ! -f "$hdd" ]; then
        echo 'Ajoute d un nouveaux disque dur synology !'
        qemu-img create -f qcow2 ${hdd} ${sizeStockage}
    fi
	
    qemu-system-x86_64 -name vm_name,process="SynoB" -nographic -boot order=c \
        -m ${ram} \
        -net nic,model=e1000 \
        -net user,hostfwd=tcp:${INTERNAL_IP}:3001-:7681,hostfwd=tcp:${INTERNAL_IP}:3002-:5000 \
        -smp ${core} \
        -drive file="${imgboot}",index=0,media=disk \
        -drive file="${hdd}",index=1,media=disk
        #-drive file="${dir}/SynologyHDD.qcow2",index=1,media=disk
