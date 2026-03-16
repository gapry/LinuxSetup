if type -q lsblk
  if test -e /dev/loop0
    # man stat
    #
    # %t     major device type in hex, for character/block device special files
    # %T     minor device type in hex, for character/block device special files
    # 
    set -l loop_major_hex (stat -c '%t' /dev/loop0)

    if test -n "$loop_major_hex"
      set -l loop_major_dec (math 0x$loop_major_hex)
      alias partition_info="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,UUID,PARTLABEL,PARTTYPENAME -e $loop_major_dec"
    else
      alias partition_info="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,UUID,PARTLABEL,PARTTYPENAME"
    end
  end
end

