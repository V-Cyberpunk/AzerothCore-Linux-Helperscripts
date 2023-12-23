#!/bin/bash

path=/home/v/azerothcore-wotlk

killall -9 authserver
tmux send-keys -t 2 'saveall' Enter
tmux send-keys -t 2 'server shutdown 10s' Enter
while ps -p $(pidof worldserver) > /dev/null; do
    sleep 1
done
#killall -9 worldserver
killall -9 htop
tmux kill-server
screen -S wow -X quit

echo "Tasks gekillt"

cd ${path}
git pull origin
cd ${path}/modules

for d in * ; do
    if [ -d "$d" ]; then
        cd ${d}
        git pull origin
        cd ..
    fi
done

cd ..

echo "GIT geupdatet"

mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/server/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static
make -j $(nproc)
make install

echo "Compiling beendet"

cd ../..
rm -rf ${path}/build

echo "CMake Cache geloescht"

mysqldump -u wow -p'wow' auth > auth.sql
mysqldump -u wow -p'wow' characters > characters.sql

echo "auth und characters gedumpt"

$HOME/server/bin/dbimport

echo "DB geupdatet"

./server.sh
