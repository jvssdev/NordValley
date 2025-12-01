{ pkgs, ... }:

let
  mako-fuzzel = pkgs.writeShellScriptBin "mako-fuzzel" ''
        #!/usr/bin/env bash

        # Script to view and interact with Mako notifications using Fuzzel

        # Function to format notifications
        format_notifications() {
            ${pkgs.mako}/bin/makoctl history | ${pkgs.jq}/bin/jq -r '
                .data[][][] |
                select(.type == "notification") |
                "\(.app_name.data // "Unknown"): \(.summary.data // "No summary") - \(.body.data // "")"
            ' 2>/dev/null
        }

        # Get notifications
        notifications=$(${pkgs.mako}/bin/makoctl history)

        # Check if there are notifications in history
        if [ -z "$notifications" ] || [ "$notifications" = '{"type":"history","data":[[]]}' ]; then
            ${pkgs.libnotify}/bin/notify-send "Mako" "No notifications in history" -a "Mako History"
            exit 0
        fi

        # Format notifications
        formatted=$(format_notifications)

        if [ -z "$formatted" ]; then
            ${pkgs.libnotify}/bin/notify-send "Mako" "Error processing notifications" -a "Mako History"
            exit 1
        fi

        # Action menu
        menu_options="View notifications
    Clear history
    Toggle Do Not Disturb
    Dismiss all"

        # Show main menu
        action=$(echo "$menu_options" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Mako: " --width=40)

        case "$action" in
            "View notifications")
                # Show notifications
                selected=$(echo "$formatted" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Notifications: " --lines=15 --width=70)
                
                if [ -n "$selected" ]; then
                    # Submenu for selected notification
                    notify_action=$(echo -e "Copy\nShow again\nClose" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Action: " --width=30)
                    
                    case "$notify_action" in
                        "Copy")
                            echo "$selected" | ${pkgs.wl-clipboard}/bin/wl-copy
                            ${pkgs.libnotify}/bin/notify-send "Copied" "Notification copied to clipboard" -a "Mako History"
                            ;;
                        "Show again")
                            # Extract notification body and show
                            app=$(echo "$selected" | cut -d: -f1)
                            msg=$(echo "$selected" | cut -d: -f2-)
                            ${pkgs.libnotify}/bin/notify-send "$app" "$msg" -a "Mako History"
                            ;;
                        "Close")
                            ;;
                    esac
                fi
                ;;
            
            "Clear history")
                ${pkgs.mako}/bin/makoctl dismiss --all
                ${pkgs.libnotify}/bin/notify-send "Mako" "History cleared" -a "Mako History"
                ;;
            
            "Toggle Do Not Disturb")
                if [[ "$(${pkgs.mako}/bin/makoctl mode)" == *"do-not-disturb"* ]]; then
                    ${pkgs.mako}/bin/makoctl mode -r do-not-disturb
                    ${pkgs.libnotify}/bin/notify-send "Mako" "Do Not Disturb disabled" -a "Mako History"
                    ${pkgs.procps}/bin/pkill -RTMIN+8 waybar  # Update waybar
                else
                    ${pkgs.mako}/bin/makoctl mode -s do-not-disturb
                    ${pkgs.libnotify}/bin/notify-send "Mako" "Do Not Disturb enabled" -a "Mako History"
                    ${pkgs.procps}/bin/pkill -RTMIN+8 waybar  # Update waybar
                fi
                ;;
            
            "Dismiss all")
                ${pkgs.mako}/bin/makoctl dismiss --all
                ${pkgs.libnotify}/bin/notify-send "Mako" "All notifications dismissed" -a "Mako History"
                ;;
        esac
  '';
in
{
  home.packages = [ mako-fuzzel ];
}
