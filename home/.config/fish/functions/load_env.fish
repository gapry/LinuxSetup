function load_env
  if test -f $argv[1]
    echo "Reading environment file: $argv[1]"
    for line in (cat $argv[1])
      if string match -qv "#*" $line; and string collect $line | string length -q
        set -l item (string split -m 1 "=" $line)
        if test (count $item) -eq 2
          set -gx $item[1] $item[2]
          echo "Exported: $item[1]"
        else
          echo "Skipped invalid line: $line"
        end
      end
    end
  else
    echo "Error: File $argv[1] not found"
  end
end
