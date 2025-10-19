#!/bin/bash
# weenos-install-flatpaks

FLATPAK_LIST="/usr/weenos/flatpakList.txt"

if [ ! -f "$FLATPAK_LIST" ]; then
	echo "weeniemount is bad at coding"
	exit 1
fi

echo "installing the optional weenOS flatpaks"
while IFS= read -r pkg; do
	[ -z "$pkg" ] && continue
	[[ "$pkg" =~ ^# ]] && continue
	
	echo "installing $pkg..."
	flatpak install -y "$pkg"
done < "$FLATPAK_LIST"

echo "done! enjoy your optimal weenOS experience"
