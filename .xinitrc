#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

export XDG_MENU_PREFIX=gnome-

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export DISPLAY=:0.0
fcitx
killall xcape
xmodmap -e 'keycode 255=space'
xmodmap -e 'keycode 65=Shift_L'
xcape -e '#65=space'
iwconfig wlp5s0 power off

if [ -n "`/etc/X11/chooser.sh`" ]; then
 command="`/etc/X11/chooser.sh`"
else
 failsafe="yes"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?* ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

if [ -n "$failsafe" ]; then
 #twm &
 #xclock -geometry 50x50-1+1 &
 #xterm -geometry 80x50+494+51 &
 #xterm -geometry 80x20+494-0 &
 #exec xterm -geometry 80x66+0+0 -name login
 exec gnome-session
else
 exec $command
fi
