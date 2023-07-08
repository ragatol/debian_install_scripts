#!/usr/bin/env sh

GODOT_ICON="https://godotengine.org/themes/godotengine/assets/download/godot_logo.svg"
GODOT_INSTALL_DIR="/opt/godot"
ICON_THEME_DIR="/usr/share/icons/hicolor"
DESKTOP_INSTALL_DIR="/usr/share/applications"

if [ $# -eq 0 ]; then
	echo "Need path to Godot .zip file to install."
	return 1
fi

if [ $USER != "root" ]; then
	echo "Need super-user privileges to install."
	return 1
fi

godot_exec="${GODOT_INSTALL_DIR}/godot"
echo "Extracting to ${godot_exec}..."
mkdir -p $GODOT_INSTALL_DIR
7z x -o$GODOT_INSTALL_DIR $1
cd $GODOT_INSTALL_DIR
mv Godot* godot

if [ ! -f icon.svg ]; then
	echo "Dowloading godot icon.svg..."
	curl "${GODOT_ICON}" -o icon.svg
fi

icon_install_path="${ICON_THEME_DIR}/scalable/apps/godot.svg"
if [ ! -f $icon_install_path ]; then
	echo "Installing icon to ${icon_install_path}..."
	cp icon.svg $icon_install_path
	gtk-update-icon-cache $ICON_THEME_DIR
fi

desktop_entry_path="${DESKTOP_INSTALL_DIR}/godot.desktop"
if [ ! -f $desktop_entry_path ]; then
	echo "Generating desktop entry in ${desktop_entry_path}..."
	echo "[Desktop Entry]
Type=Application
Name=Godot
Comment=Godot Game Engine
Exec=${godot_exec}
Icon=godot
Categories=Development;
" | tee $desktop_entry_path
fi

if [ ! -f /usr/local/bin/godot ]; then
	echo "Linking godot executable to /usr/local/bin/godot"
	ln -s $godot_exec /usr/local/bin/godot
fi

echo "Done!"
