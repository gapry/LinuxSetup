function pcs-watch --description "Monitor page cache status of a file every second"
  if test (count $argv) -eq 0
    echo "Usage: pcs-watch <file_path>"
    return 1
  end

  watch -n 1 -d "pcstat $argv"
end
