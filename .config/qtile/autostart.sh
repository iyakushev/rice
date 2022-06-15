#!/usr/bin/env bash 

# Office specific setting
# set 1st display to rotate left
xrandr --output DVI-D-0 --rotate left
xsettingsd &

# startup section
picom --experimental-backends -b
/usr/bin/emacs --daemon &
conky -c $HOME/.config/conky/doomone-qtile.conkyrc
volumeicon &
nm-applet &
feh --bg-scale $HOME/.config/wall.jpg
