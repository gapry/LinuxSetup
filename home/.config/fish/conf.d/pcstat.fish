if type -q pcstat
  alias pcs="pcstat"
  alias pcs-all="pcstat /bin/* /usr/bin/*"
  alias pcs-summary="pcstat -terse -pps"
end
