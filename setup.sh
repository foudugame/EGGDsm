#!/bin/bash
cd /
git clone https://github.com/foudugame/dsm.git
cd /BSyno
cat boot.tar.* > dsm.tar
tar -xvf dsm.tar -C /BSyno
rm boot.tar.*
rm dsm.tar   
chmod +x /BSyno/start.sh

