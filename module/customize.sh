SKIPUNZIP=1

dir=/data/adb/beszel
if $ARCH != "arm" && $ARCH != "arm64" && $ARCH != "x64"; then
    ui_print "Unsupported architecture: ${ARCH}"
    exit 1
fi

ui_print "Extracting files..."
unzip -o "${ZIPFILE}" -x 'META-INF/*' -d $MODPATH >&2
mkdir -p ${dir}

if [ -f "${dir}/setting" ]; then
    mv "${dir}/setting" "${dir}/setting.bak"
fi

$dir/scripts/beszel.stop

set_perm_recursive ${MODPATH}/system/bin 0 0 0755 0755
cp -r ${MODPATH}/beszel/* ${dir}/
if [ -f "${dir}/setting.bak" ]; then
    cp "${dir}/setting.bak" "${dir}/setting"
else
    cp ${MODPATH}/beszel/scripts/setting ${dir}/setting
fi
mv ${dir}/bin/${ARCH} ${dir}/beszel_agent
rm -r ${dir}/bin

rm -rf ${MODPATH}/beszel

sleep 1

chmod 755 -Rf $dir/*
$dir/scripts/beszel.start