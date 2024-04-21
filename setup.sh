#!/bin/bash
HOME="/home/container"
INSTALL="$HOME"
EGGDsm="$INSTALL/EGGDsm"

HOMEA="$HOME/linux/.apt"
STAR1="$HOMEA/lib:$HOMEA/usr/lib:$HOMEA/var/lib:$HOMEA/usr/lib/x86_64-linux-gnu:$HOMEA/lib/x86_64-linux-gnu:$HOMEA/lib:$HOMEA/usr/lib/sudo"
STAR2="$HOMEA/usr/include/x86_64-linux-gnu:$HOMEA/usr/include/x86_64-linux-gnu/bits:$HOMEA/usr/include/x86_64-linux-gnu/gnu"
STAR3="$HOMEA/usr/share/lintian/overrides/:$HOMEA/usr/src/glibc/debian/:$HOMEA/usr/src/glibc/debian/debhelper.in:$HOMEA/usr/lib/mono"
STAR4="$HOMEA/usr/src/glibc/debian/control.in:$HOMEA/usr/lib/x86_64-linux-gnu/libcanberra-0.30:$HOMEA/usr/lib/x86_64-linux-gnu/libgtk2.0-0"
STAR5="$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/modules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/printbackends"
STAR6="$HOMEA/usr/lib/x86_64-linux-gnu/samba/:$HOMEA/usr/lib/x86_64-linux-gnu/pulseaudio:$HOMEA/usr/lib/x86_64-linux-gnu/blas:$HOMEA/usr/lib/x86_64-linux-gnu/blis-serial"
STAR7="$HOMEA/usr/lib/x86_64-linux-gnu/blis-openmp:$HOMEA/usr/lib/x86_64-linux-gnu/atlas:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-miners-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/lapack:$HOMEA/usr/lib/x86_64-linux-gnu/gedit"
STARALL="$STAR1:$STAR2:$STAR3:$STAR4:$STAR5:$STAR6:$STAR7"
export LD_LIBRARY_PATH=$STARALL
export PATH="$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
export BUILD_DIR=$HOMEA

bold=$(echo -en "\e[1m")
nc=$(echo -en "\e[0m")
lightblue=$(echo -en "\e[94m")
lightgreen=$(echo -en "\e[92m")

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP
./dist/proot -S . /bin/bash -c "apt list --installed | grep gcc" > /dev/null 2>&1 &

if [[ -f "./installed" ]]; then
    echo "Starting EGGDsm"
    ./dist/proot -S . /bin/bash --login $EGGDsm/bsyno/start.sh
    #./dist/proot -S . /bin/bash --login 
else
    echo "Downlods the files"
    git clone https://github.com/foudugame/EGGDsm.git

    echo "Installing the files ..."
    
    cd $EGGDsm/install
    cat vm.tar.* > vmUN.tar
    tar -xvf vmUN.tar -C $INSTALL
    rm -rf vmUN.tar
    
    cp $EGGDsm/install/apth $INSTALL/apth 
    cd $INSTALL
    chmod +x apth
    ./apth unzip >/dev/null 
    
    cd $INSTALL/vm
    mv root.zip $INSTALL
    mv root.tar.gz $INSTALL
    cd $INSTALL
    $INSTALL/linux/usr/bin/unzip root.zip
    tar -xf root.tar.gz

    chmod +x ./dist/proot
    #rm -R $INSTALL/vm
    
    rm -rf root.zip
    rm -rf root.tar.gz
        
    ./dist/proot -S . /bin/bash -c "mv apth /usr/bin/"
    ./dist/proot -S . /bin/bash -c "mv unzip /usr/bin/"
    #./dist/proot -S . /bin/bash -c "dpkg --add-architecture i386"
    ./dist/proot -S . /bin/bash -c "apt-get update"
    ./dist/proot -S . /bin/bash -c "apt-get -y upgrade"
    ./dist/proot -S . /bin/bash -c "apt-get -y install curl busybox"
    ./dist/proot -S . /bin/bash -c "apt-get -y install wget"
    ./dist/proot -S . /bin/bash -c "apt-get -y install neofetch"
    #./dist/proot -S . /bin/bash -c "apt install -y lib32gcc-s1 lib32stdc++6 unzip curl iproute2 tzdata libgdiplus libsdl2-2.0-0:i386 "
    #./dist/proot -S . /bin/bash -c "curl -sL https://deb.nodesource.com/setup_14.x | bash -"
    #./dist/proot -S . /bin/bash -c "apt install -y nodejs"  
    #./dist/proot -S . /bin/bash -c "mkdir /node_modules"  
    #./dist/proot -S . /bin/bash -c "npm install --prefix / ws"  
    #./dist/proot -S . /bin/bash -c "apt-get -y install x11-xserver-utils git kmod"    
    #./dist/proot -S . /bin/bash -c "apt-get -y install qemu-system qemu-utils qemu-system-gui qemu-kvm"
    #./dist/proot -S . /bin/bash -c "apt-get -y install qemu-kvm virt-manager virtinst libvirt-clients bridge-utils libvirt-daemon-system"
    ./dist/proot -S . /bin/bash -c "curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py"
    ./dist/proot -S . /bin/bash -c "chmod +x /bin/systemctl"    

    rm -rf $EGGDsm/bsyno/*.vmdk > /dev/null 2>&1 &
    TAG="$(curl -s https://api.github.com/repos/AuxXxilium/arc/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')"
    ./dist/proot -S . /bin/bash -c "busybox wget \"https://github.com/AuxXxilium/arc/releases/download/${TAG}/arc-${TAG}.vmdk-dyn.zip\" -O \"$EGGDsm/bsyno/arc-vmdk.zip\""
    cd $EGGDsm/bsyno
    $INSTALL/linux/usr/bin/unzip arc-vmdk.zip
    rm -rf $EGGDsm/bsyno/arc-vmdk.zip > /dev/null 2>&1 &
    chmod +x $EGGDsm/bsyno/*.vmdk
    chmod +x $EGGDsm/bsyno/start.sh
    cd $INSTALL

./dist/proot -S . /bin/bash -c "apt install -y git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev build-essential libusbredirhost-dev libusb-dev libusb-1.0-0-dev libseccomp-dev libcap-ng-dev libaio-dev liblzo2-dev libzip-dev libbz2-dev wget libsdl2-dev libspice-protocol-dev libspice-server-dev"
./dist/proot -S . /bin/bash -c "mkdir $EGGDsm/qemu-build"
./dist/proot -S . /bin/bash -c "mkdir $EGGDsm/qemu-build/build"
./dist/proot -S . /bin/bash -c "cd $EGGDsm/qemu-build"
./dist/proot -S . /bin/bash -c "wget 'https://download.qemu.org/qemu-4.2.0.tar.xz'"
./dist/proot -S . /bin/bash -c "tar -x -f qemu-4.2.0.tar.xz"
./dist/proot -S . /bin/bash -c "cd build"
./dist/proot -S . /bin/bash -c "../qemu-4.2.0/configure --target-list=x86_64-softmmu --prefix=/opt/qemu-custom --enable-kvm --enable-tools--enable-spice --enable-vnc --enable-sdl  --enable-libusb --enable-usb-redir --enable-seccomp --enable-linux-aio --enable-avx2 --enable-coroutine-pool --enable-cap-ng --enable-lzo --enable-bzip2"
./dist/proot -S . /bin/bash -c "make -j4"
    
    touch installed
    
    #./dist/proot -S . /bin/bash --login
    ./dist/proot -S . /bin/bash --login $EGGDsm/bsyno/start.sh
fi
