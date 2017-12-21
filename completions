# Completions for wlancli

function __wlancli_list_devices
   nmcli device wifi rescan ^ /dev/null
   nmcli --fields SSID device wifi list | \
            tail -n +2 | \
            sort -u | \
            grep -v '^\-\-' | tr ' ' '\n'
end
  
complete -c wlancli -l help --description "Display help and exit"
complete -c wlancli -l rescan --description "Rescan for available WiFi access points"
complete -c wlancli -l ls --description "List available WiFi access points"
complete -x -c wlancli -l connect -a "(__wlancli_list_devices)" \
	--description "Connect to a WiFi access point specified by SSID or BSSID"
complete -c wlancli  -l toggle --description "Toggle WiFi radio switch"
complete -x -c wlancli -a "(__wlancli_list_devices)"
