#!/bin/sh

##
# Remove existing scripts
##
for i in /home/* /root; do
	if [ -d "$i/.gnome2/nautilus-scripts" ]; then
		rm -f "$i/.gnome2/nautilus-scripts/compare"
		rm -f "$i/.gnome2/nautilus-scripts/compare_to_selected"
		rm -f "$i/.gnome2/nautilus-scripts/select_for_compare"
	fi
	if [ -d "$i/.kde4/share/kde4/services/ServiceMenus" ]; then
		rm -f "$i/.kde4/share/kde4/services/ServiceMenus/beyondcompare.desktop"
		rm -f "$i/.kde4/share/kde4/services/ServiceMenus/beyondcompare_compare.desktop"
		rm -f "$i/.kde4/share/kde4/services/ServiceMenus/beyondcompare_more.desktop"
		rm -f "$i/.kde4/share/kde4/services/ServiceMenus/beyondcompare_select.desktop"
	fi
	if [ -d "$i/.kde/share/kde4/services/ServiceMenus" ]; then
		rm -f "$i/.kde/share/kde4/services/ServiceMenus/beyondcompare.desktop"
		rm -f "$i/.kde/share/kde4/services/ServiceMenus/beyondcompare_compare.desktop"
		rm -f "$i/.kde/share/kde4/services/ServiceMenus/beyondcompare_more.desktop"
		rm -f "$i/.kde/share/kde4/services/ServiceMenus/beyondcompare_select.desktop"
	fi
	if [ -d "$i/.kde/share/apps/konqueror/servicemenus" ]; then
		rm -f "$i/.kde/share/apps/konqueror/servicemenus/beyondcompare.desktop"
		rm -f "$i/.kde/share/apps/konqueror/servicemenus/beyondcompare_compare.desktop"
		rm -f "$i/.kde/share/apps/konqueror/servicemenus/beyondcompare_more.desktop"
		rm -f "$i/.kde/share/apps/konqueror/servicemenus/beyondcompare_select.desktop"
	fi
done

##
# Put in new Context Menu Script on anything that isn't KDE 3.5.  For that
# one the bcompare.sh script will install scripts.
##
if [ `arch` = x86_64 ]; then
  LIB_ARCH="amd64"
else
  LIB_ARCH="i386"
fi
for EXT_LIB in /usr/lib /usr/lib64
do
	if [ -d "$EXT_LIB/kde4" ]; then
		testver="4.6.1"
		fullver=`cd /tmp && kde4-config -v`
		kver=`echo ${fullver} | 		/usr/bin/awk 'BEGIN { FS = "latform: " } ; { print $2 }' | 		/usr/bin/awk 'BEGIN { FS = "(" } ; { print $1 }' | 		/usr/bin/awk 'BEGIN { FS = "." } ; { printf("%03d.%03d.%03d", $1, $2, $3) }'`
		smaller=`/bin/echo -e "$kver\n$testver" | /usr/bin/sort -V | /usr/bin/head -1`
		if [ "$smaller" = "$testver" ]; then
			cp /usr/lib/beyondcompare/ext/bcompare_ext_kde.$LIB_ARCH.so 				$EXT_LIB/kde4/bcompare_ext_kde.so
			cp /usr/lib/beyondcompare/ext/bcompare_ext_kde.desktop /usr/share/kde4/services/
		else
			cp /usr/lib/beyondcompare/ext/bcompare_ext_konq.$LIB_ARCH.so 				$EXT_LIB/kde4/bcompare_ext_konq.so
			cp /usr/lib/beyondcompare/ext/bcompare_ext_konq.desktop /usr/share/kde4/services/
		fi
	fi
	if [ -d "$EXT_LIB/nautilus/extensions-3.0" ]; then
		cp /usr/lib/beyondcompare/ext/bcompare-ext-nautilus.$LIB_ARCH.so 			$EXT_LIB/nautilus/extensions-3.0/bcompare-ext-nautilus.so
	elif [ -d "$EXT_LIB/nautilus/extensions-2.0" ]; then
		cp /usr/lib/beyondcompare/ext/bcompare-ext-nautilus.$LIB_ARCH.so 			$EXT_LIB/nautilus/extensions-2.0/bcompare-ext-nautilus.so
	elif [ -d "$EXT_LIB/nautilus/extensions-1.0" ]; then
		cp /usr/lib/beyondcompare/ext/bcompare-ext-nautilus.$LIB_ARCH.so 			$EXT_LIB/nautilus/extensions-1.0/bcompare-ext-nautilus.so
	fi
	if [ -d "$EXT_LIB/thunarx-2" ]; then
		cp /usr/lib/beyondcompare/ext/bcompare-ext-thunarx.$LIB_ARCH.so 			$EXT_LIB/thunarx-2/bcompare-ext-thunarx.so
	elif [ -d "$EXT_LIB/thunarx-1" ]; then
		cp /usr/lib/beyondcompare/ext/bcompare-ext-thunarx.$LIB_ARCH.so 			$EXT_LIB/thunarx-1/bcompare-ext-thunarx.so
	fi
	if [ -d "$EXT_LIB/nemo/extensions-3.0" ]; then
		cp /usr/lib/beyondcompare/ext/bcompare-ext-nemo.$LIB_ARCH.so 			$EXT_LIB/nemo/extensions-3.0/bcompare-ext-nemo.so
	fi
	if [ -d "$EXT_LIB/caja/extensions-3.0" ]; then
		cp /usr/lib/beyondcompare/ext/bcompare-ext-caja.$LIB_ARCH.so 			$EXT_LIB/caja/extensions-3.0/bcompare-ext-caja.so
	fi
done

##
# Set up Beyond Compare mime types and associations
##
update-mime-database /usr/share/mime &> /dev/null
if [ -f /usr/share/applications/mimeinfo.cache ]; then
	echo "application/beyond.compare.snapshot=bcompare.desktop" >> 		/usr/share/applications/mimeinfo.cache
fi

if [ -x /usr/bin/update-desktop-database ]; then
  /usr/bin/update-desktop-database -q usr/share/applications >/dev/null 2>&1
fi
