#!/bin/bash

rm compilelog.log

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>compilelog.log 2>&1

path=/home/$USER/azerothcore-wotlk

killall -9 authserver
killall -9 worldserver
killall -9 htop
tmux kill-server
screen -S wow -X quit

echo "Tasks gekillt"

cd ${path}
git pull origin master --no-edit
git checkout master
cd ${path}/modules

for d in * ; do
    if [ -d "$d" ]; then
        cd ${d}
        git pull origin --no-edit
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

mysqldump -u user -p'pw' auth > auth.sql
mysqldump -u user -p'pw' world > world.sql
mysqldump -u user -p'pw' characters > characters.sql

echo "auth und characters gedumpt"

$HOME/server/bin/dbimport

echo "DB geupdatet"

$HOME/server.sh
