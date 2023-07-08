#!/usr/bin/env sh

if [ $USER != "root" ]; then
	echo "Need super-user privileges to install."
	return 1
fi

if [ -z $1 ] || [ ! -f $1 ]; then
	echo "Need path to the compressed archive download from blender.com."
	return 1
fi

if [ -d /opt/blender ]; then
	echo "Removing previous Blender installation..."
	rm -r /opt/blender
fi

echo "Extracting Blender to /opt/blender..."
tar -xf $1 -C /opt
cd /opt
mv blender* blender
chmod -R a+rx blender
cd /opt/blender

if [ ! -f /usr/share/icons/hicolor/scalable/apps/blender.svg ]; then
	echo "Installing blender icon..."
	ln blender.svg /usr/share/icons/hicolor/scalable/apps/blender.svg
	gtk-update-icon-cache /usr/share/icons/hicolor
fi

if [ ! -f /usr/local/bin/blender ]; then
	echo "Linking blender executable to /usr/local/bin/blender..."
	ln -s /opt/blender/blender /usr/local/bin/blender
fi

if [ ! -f /usr/share/applications/blender.desktop ]; then
	echo "Adding desktop entry..."
	ln /opt/blender/blender.desktop /usr/share/applications/blender.desktop
fi

echo "Done!"
