# Completions for wlancli

function __wlancli_list_devices
   nmcli device wifi rescan ^ /dev/null
   # 1. get all access points
   # 2. remove header
   # 3. remove duplicate access point entries
   # 4. remove un-named / hidden access points
   # 5. remove leading & trailing spaces
   # 6. sort entries by signal strength
   # 7. format output
   nmcli --fields SIGNAL,BARS,SSID device wifi list | \
            tail -n +2 | \
            sort -u -k3 | \
            grep -v '\-\-' | \
            sed 's/ *$//' | \
            sort -nrk1 | \
            awk ' {
               ssid=substr($0, index($0, $3))
               signal=$1
               bars=$2
               printf("%s\t%s %02d\n", ssid, bars, signal)
            }'
end

# default to list devices
# -k (keep order) is ignored in fish < 3.0
complete -k -x -c wlancli -a "(__wlancli_list_devices)"

complete -c wlancli -l help \
   --description "Display help and exit"

complete -c wlancli -l rescan \
   --description "Rescan for available WiFi access points"

complete -c wlancli -l ls \
   --description "List available WiFi access points"

# -k (keep order) is ignored in fish < 3.0
complete -k -x -c wlancli -l connect -a "(__wlancli_list_devices)"

complete -c wlancli  -l toggle \
   --description "Toggle WiFi radio switch"
