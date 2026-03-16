if type -q lsblk
  set -l loop_opt

  if test -e /dev/loop0
    # man stat
    #
    # %t     major device type in hex, for character/block device special files
    # %T     minor device type in hex, for character/block device special files
    # 
    set -l loop_major_hex (stat -c '%t' /dev/loop0)

    if test -n "$loop_major_hex"
      set -l loop_major_dec (math 0x$loop_major_hex)
      set loop_opt "-e $loop_major_dec"
    end
  end
  
  alias partition_info="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,UUID,PARTLABEL,PARTTYPENAME $loop_opt"
end

