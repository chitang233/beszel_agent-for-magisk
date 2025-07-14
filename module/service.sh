until [ $(getprop init.svc.bootanim) = "stopped" ] ; do
    sleep 5
done

service_path=`realpath $0`
module_dir=`dirname ${service_path}`
dir="/data/adb/beszel"
script_dir="$dir/scripts"

$script_dir/beszel.start

inotifyd ${script_dir}/beszel.inotify ${module_dir} >> /dev/null &