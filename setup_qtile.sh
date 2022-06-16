#!/usr/bin/env bash
~/rice/fast_install.sh

SCRIPT=$(readlink -f $0)
BASEDIR=$(dirname "$SCRIPT")
# =====
# QTILE
echo "[1/3] Setting up Qtile"
echo "      * Installing dependencies"
sudo apt install python3-cffi python3-xcffib python3-cairocffi libpangocairo-1.0-0
pip install --no-cache-dir --no-deps --ignore-installed cairocffi xcffib
pip install psutil
sudo cp ${BASEDIR}/qtile.desktop /usr/share/xsessions/

echo "      * Cloning sources"
cd ~/
git clone https://github.com/qtile/qtile.git 
cd qtile && pip install .

# =====
# SLOCK
echo "[2/3] Setting up SLOCK"
cd ${BASEDIR}/slock
sudo make install


# =====
# PICOM
echo "[3/3] Setting up PICOM"
echo "      * Installing dependencies"
sudo add-apt-repository ppa:papirus/papirus
sudo apt update && sudo apt install papirus-icon-theme
sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson
cd ~/
git clone https://github.com/yshui/picom
cd picom && git submodule update --init --recursive
meson --buildtype=release . build
sudo ninja -C build install


echo "✨Done"
