#!/usr/bin/env sh

INSTALL_DIR="/opt/blender"

if [ "${USER}" != "root" ]; then
	echo "Need super-user privileges to install."
	return 1
fi

if [ -z "${1}" ] || [ ! -f "${1}" ]; then
	echo "Need path to the compressed archive download from blender.com."
	return 1
fi

if [ -d "${INSTALL_DIR}" ]; then
	echo "Removing previous Blender installation..."
	rm -r "${INSTALL_DIR}"
fi

echo "Extracting Blender to ${INSTALL_DIR}..."
tar -xf "${1}" --strip-components=1 --one-top-level="${INSTALL_DIR}/"
chmod -R a+rx "${INSTALL_DIR}"

if [ ! -f /usr/share/icons/hicolor/scalable/apps/blender.svg ]; then
	echo "Installing blender icon..."
	ln "${INSTALL_DIR}/blender.svg" /usr/share/icons/hicolor/scalable/apps/blender.svg
	gtk-update-icon-cache /usr/share/icons/hicolor
fi

if [ ! -f /usr/local/bin/blender ]; then
	echo "Linking blender executable to /usr/local/bin/blender..."
	ln -s "${INSTALL_DIR}/blender" /usr/local/bin/blender
fi

if [ ! -f /usr/share/applications/blender.desktop ]; then
	echo "Adding desktop entry..."
	ln "${INSTALL_DIR}/blender.desktop" /usr/share/applications/blender.desktop
fi

echo "Done!"
