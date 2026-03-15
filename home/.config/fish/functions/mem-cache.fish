function mem-cache --description "Show memory cache status with unit conversion"
  set -l unit "MB"
  set -l divisor 1024

  if test (count $argv) -gt 0; and test $argv[1] = "gb"
    set unit "GB"
    set divisor 1048576
  end

  cat /proc/meminfo | grep -E "^(Cached|Dirty|Writeback):" | awk -v d=$divisor -v u=$unit '{print $1, $2/d, u}'
end
