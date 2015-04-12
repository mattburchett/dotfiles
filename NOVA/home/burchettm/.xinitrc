export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
start-pulseaudio-x11 &
xfce4-panel &
dbus-launch gnome-session
