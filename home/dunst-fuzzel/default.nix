{ pkgs, ... }:

let
  dunst-fuzzel = pkgs.writeShellScriptBin "dunst-fuzzel" ''
        #!/usr/bin/env bash

        tmpdir=$(mktemp -d)
        history_file="$tmpdir/history.json"
        
        ${pkgs.dunst}/bin/dunstctl history > "$history_file"

        if [ ! -f "$history_file" ] || [ ! -s "$history_file" ]; then
            rm -rf "$tmpdir"
            ${pkgs.libnotify}/bin/notify-send "Dunst" "No notifications in history" -a "Dunst History"
            exit 0
        fi

        notification_count=$(${pkgs.jq}/bin/jq '.data[0] | length' "$history_file" 2>/dev/null)

        if [ -z "$notification_count" ] || [ "$notification_count" = "0" ] || [ "$notification_count" = "null" ]; then
            rm -rf "$tmpdir"
            ${pkgs.libnotify}/bin/notify-send "Dunst" "No notifications in history" -a "Dunst History"
            exit 0
        fi

        data_file="$tmpdir/data"
        display_file="$tmpdir/display"

        ${pkgs.jq}/bin/jq -r '.data[0][] | 
            "\(.appname.data)|||" + 
            "\(.summary.data)|||" + 
            (if .body.data then .body.data else "" end)' \
            "$history_file" > "$data_file"

        while IFS='|||' read -r app summary body; do
            if [ -n "$body" ]; then
                echo "$app: $summary - $body"
            else
                echo "$app: $summary"
            fi
        done < "$data_file" > "$display_file"

        if [ ! -s "$display_file" ]; then
            rm -rf "$tmpdir"
            ${pkgs.libnotify}/bin/notify-send "Dunst" "No notifications to display" -a "Dunst History"
            exit 0
        fi

        menu_options="View notifications
    Clear history
    Toggle Do Not Disturb
    Dismiss all"

        action=$(echo "$menu_options" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Dunst: " --width=40)

        case "$action" in
            "View notifications")
                selected=$(cat "$display_file" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Notifications: " --lines=15 --width=70)
                
                if [ -n "$selected" ]; then
                    line_number=$(grep -n -F "$selected" "$display_file" | head -1 | cut -d: -f1)
                    
                    if [ -n "$line_number" ]; then
                        selected_data=$(sed -n "''${line_number}p" "$data_file")
                        
                        IFS='|||' read -r app summary body <<< "$selected_data"
                        
                        notify_action=$(echo -e "Copy\nShow again\nClose" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Action: " --width=30)
                        
                        case "$notify_action" in
                            "Copy")
                                if [ -n "$body" ]; then
                                    printf '%s - %s' "$summary" "$body" | ${pkgs.wl-clipboard}/bin/wl-copy
                                    ${pkgs.libnotify}/bin/notify-send "Copied" "Notification copied to clipboard" -a "Dunst History"
                                else
                                    printf '%s' "$summary" | ${pkgs.wl-clipboard}/bin/wl-copy
                                    ${pkgs.libnotify}/bin/notify-send "Copied" "Summary copied" -a "Dunst History"
                                fi
                                ;;
                            "Show again")
                                if [ -n "$body" ]; then
                                    ${pkgs.libnotify}/bin/notify-send "$summary" "$body" -a "$app"
                                else
                                    ${pkgs.libnotify}/bin/notify-send "$summary" "" -a "$app"
                                fi
                                ;;
                            "Close")
                                ;;
                        esac
                    fi
                fi
                ;;
            
            "Clear history")
                ${pkgs.dunst}/bin/dunstctl history-clear
                ${pkgs.dunst}/bin/dunstctl close-all
                ${pkgs.libnotify}/bin/notify-send "Dunst" "History cleared" -a "Dunst History"
                ;;
            
            "Toggle Do Not Disturb")
                if ${pkgs.dunst}/bin/dunstctl is-paused | grep -q "true"; then
                    ${pkgs.dunst}/bin/dunstctl set-paused false
                    ${pkgs.libnotify}/bin/notify-send "Dunst" "Do Not Disturb disabled" -a "Dunst History"
                else
                    ${pkgs.dunst}/bin/dunstctl set-paused true
                    ${pkgs.libnotify}/bin/notify-send "Dunst" "Do Not Disturb enabled" -a "Dunst History"
                fi
                ;;
            
            "Dismiss all")
                ${pkgs.dunst}/bin/dunstctl close-all
                ${pkgs.libnotify}/bin/notify-send "Dunst" "All notifications dismissed" -a "Dunst History"
                ;;
        esac

        rm -rf "$tmpdir"
  '';
in
{
  home.packages = [ dunst-fuzzel ];
}
