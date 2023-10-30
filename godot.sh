#!/usr/bin/env sh

ICON_URL="https://godotengine.org/themes/godotengine/assets/download/godot_logo.svg"
INSTALL_DIR="/opt/godot"
ICON_THEME_DIR="/usr/share/icons/hicolor"
DESKTOP_INSTALL_DIR="/usr/share/applications"

if [ $# -eq 0 ]; then
	echo "Need path to Godot .zip file to install."
	return 1
fi

if [ "${USER}" != "root" ]; then
	echo "Need super-user privileges to install."
	return 1
fi

EXEC="${INSTALL_DIR}/godot"
echo "Extracting to ${EXEC}..."
tar -xf "${1}" --one-level-dir="${INSTALL_DIR}"
mv "${INSTALL_DIR}/Godot*" "${EXEC}"

if [ ! -f /usr/local/bin/godot ]; then
	echo "Linking godot executable to /usr/local/bin/godot"
	ln -s "${EXEC}" /usr/local/bin/godot
fi

ICON="${ICON_THEME_DIR}/scalable/apps/godot.svg"
if [ ! -f "${ICON}" ]; then
	echo "Dowloading and installing godot icon..."
	curl "${ICON_URL}" -o "${ICON}"
	gtk-update-icon-cache "${ICON_THEME_DIR}"
fi

DOT_DESKTOP="${DESKTOP_INSTALL_DIR}/godot.desktop"
if [ ! -f "${DOT_DESKTOP}" ]; then
	echo "Generating desktop entry in ${DOT_DESKTOP}..."
	echo "[Desktop Entry]
Type=Application
Name=Godot
Comment=Godot Game Engine
Exec=${EXEC}
Icon=godot
Categories=Development;
" | tee "${DOT_DESKTOP}"
fi

echo "Done!"
