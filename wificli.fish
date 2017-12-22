#!/usr/bin/env fish
set -l options (fish_opt --short h \
                         --long help \
                         --long-only)

set options $options (fish_opt --short c \
                               --long connect \
                               --long-only \
                               --required-val)

set options $options (fish_opt --short l \
                               --long ls \
                               --long-only)

set options $options (fish_opt --short r \
                               --long rescan \
                               --long-only)

set options $options (fish_opt --short t \
                               --long toggle \
                               --long-only)

argparse $options -- $argv ;or exit 1

function rescan_access_points
   nmcli device wifi rescan ^ /dev/null
end

function get_access_points
   set fields SSID,CHAN,RATE,SIGNAL,BARS,SECURITY
   unbuffer nmcli --fields $fields device wifi list | \
            grep -v '^.\{5\}\-\-' | \
            head --lines 10
end

function toggle_wifi
   if test (nmcli radio wifi) = "enabled"
      echo "turning off wifi..."
      nmcli radio wifi off
   else
      echo "turning on wifi..."
      nmcli radio wifi on
   end
end

function get_wifi_connections
   set wifi_type "802-11-wireless"
   # only output wifi network connections
   # nmcli doesn't provide such functionality, so I had to improvise :)
   nmcli --fields NAME,TYPE connection show $argv | \
   awk -F "$wifi_type" "/$wifi_type/ { print \$1 }"
end

function show_usage
   set path (basename (status --current-filename))
   echo "Usage: $path [--connect <SSID>] [--ls] [--help] [--toggle] [--rescan]"
end

function connect_to -a ssid
   # get all non-hidden access points
   set access_points (nmcli --fields SSID device wifi list | \
                      tail -n +2 | \
                      grep -v '^\-\-' | \
                      tr ' ' '\n' | \
                      sort -u)

   if not contains $ssid $access_points
      echo "error: no access point with SSID '$ssid' found."
      exit 1
   end

   # if we're already connected to the given ssid, don't do anything.
   if contains $ssid (get_wifi_connections --active | tr ' ' '\n')
      echo "error: already connected to '$ssid'." 1>&2
      exit 0
   end

   # check that if a connection already exists in network manager.
   if contains $ssid (get_wifi_connections | tr ' ' '\n')
      nmcli connection up id $ssid
      return $status
   end

   # connect to the given ssid (and create new network-manager connection)
   read -i -P "Password for '$ssid': " passwd
   nmcli device wifi connect $ssid password $passwd
   return $status
end

if set -q _flag_toggle
   toggle_wifi
   exit $status
end

if set -q _flag_connect
   connect_to $_flag_connect[1]
   exit $status
end

if set -q _flag_ls
   get_access_points
   exit $status
end

if set -q _flag_rescan
   rescan_access_points
   exit $status
end

# if --help was used, or no cmdargs passed
if set -q _flag_help ;or not count $argv > /dev/null
   show_usage ;and exit 0
end

if test (count $argv) -gt 1
   echo "error: too many arugments passed. try --help." 1>&2
   exit 1
end

# fallback to use the first parameter as an ssid
connect_to $argv[1]
