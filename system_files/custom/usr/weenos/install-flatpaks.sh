#!/bin/bash
# weenos-install-flatpaks

FLATPAK_LIST="/usr/weenos/flatpakList.txt"

if [ ! -f "$FLATPAK_LIST" ]; then
	echo "weeniemount is bad at coding"
	exit 1
fi

echo "installing the optional weenOS flatpaks"
spinner='|/-\'
while IFS= read -r pkg; do
	[ -z "$pkg" ] && continue
	[[ "$pkg" =~ ^# ]] && continue

	printf "installing %s" "$pkg"
	flatpak install -y "$pkg" >/dev/null 2>&1 &
	pid=$!

	i=0
	while kill -0 $pid 2>/dev/null; do
		printf "\r${spinner:i++%${#spinner}:1} installing %s" "$pkg"
		sleep 0.1
	done
	wait $pid
	printf "\n"
done < "$FLATPAK_LIST"

echo "done! enjoy your optimal weenOS experience"