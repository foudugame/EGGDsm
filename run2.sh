#!/bin/sh

# chmod +x -R /SynoBoot && cd /SynoBoot && ./synomenu.sh install

dir="/home/container"
hdd="${dir}/HDD2.qcow2"
imgboot="${dir}/arc-flat.vmdk"
ram=3G
core=2
sizeStockage=2000G

    echo "https://github.com/AuxXxilium/arc/releases/download/"

    if [ ! -f "$hdd" ]; then
        echo 'Ajoute d un nouveaux disque dur synology !'
        qemu-img create -f qcow2 ${hdd} ${sizeStockage}
    fi
	
    qemu-system-x86_64 -name vm_name,process="SynoB" -nographic -enable-kvm -boot order=c \
        -m ${ram} \
        -net nic,model=e1000 \
        -net user,hostfwd=tcp::7681-:7681,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443,hostfwd=tcp::5000-:5000,hostfwd=tcp::5001-:5001,hostfwd=tcp::3307-:3307,hostfwd=tcp::222-:222,hostfwd=tcp::221-:221 \
        -machine type=q35 \
        -cpu host -smp ${core} \
        -device qemu-xhci -device usb-tablet \
        -drive file="${imgboot}",index=0,media=disk \
        -drive file="${hdd}",index=1,media=disk
        #-drive file="${dir}/SynologyHDD.qcow2",index=1,media=disk
