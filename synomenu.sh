#!/bin/sh

# chmod +x -R /SynoBoot && cd /SynoBoot && ./synomenu.sh install

hdd="${HOME}/HDD.qcow2"
imgboot="${HOME}/arc-flat.vmdk"
ram=3G
core=2
sizeStockage=2000G


BootSynology() {
    if ! [ -x "$(command -v qemu-system-x86_64)" ]; then
        apt update -y
        apt upgrade -y
        apt install -y qemu-system qemu-utils qemu-system-gui qemu-kvm
        apt install qemu-kvm virt-manager virtinst libvirt-clients bridge-utils libvirt-daemon-system -y
    fi
	
    chmod -R 777 ${HOME}
    cd ${HOME}
	
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

}


Boot() {
    while true
    do
        echo 'Start : server !'
        BootSynology
	echo 'Stop : server !'
        sleep 1	
    done	
}

Install() {

tee /lib/systemd/system/synomenu.service <<EOF
[Unit]
Description=SynoBoot serveur web/mysql/ftp/...

[Service]
ExecStart=${dir}/synomenu.sh
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl status synomenu.service 
}


case "$1" in
        start)
		pkill SynoB
                BootSynology 
                ;;
        stop)
                pkill SynoB
                ;;
        restart)
                pkill SynoB
                BootSynology
                ;;
        reload)
                pkill SynoB
                BootSynology
		        ;;
        status)
		systemctl status synomenu.service 
		        ;;				
        install)
                Install
				
		        ;;				
        *)
		pkill SynoBoot
                BootSynology 
esac

