# load XTerm config
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# boot fcitx for input japanese
eval "$(dbus-launch --sh-syntax --exit-with-session)"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export DefaultImModule=fcitx

# disable beep sound
sudo modprobe -r pcspkr

# set wallpaper
#fbsetbg -f ~/.fluxbox/high-sierra.jpeg
#fbsetbg -l

# key repeat
xset r rate 300 60

# set font path
xset +fp /usr/share/fonts/ricty

# start
# exec startfluxbox
