function pcs-check --description "Check if specific files are in page cache"
  if test (count $argv) -eq 0
    echo "Usage: pcs-check <file_path>"
    return 1
  end

  for file in $argv
    if test -f $file
      pcstat $file
    else
      echo "Error: $file is not a valid file."
    end
  end
end
