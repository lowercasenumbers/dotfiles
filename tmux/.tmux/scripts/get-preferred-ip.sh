#!/bin/bash
# Returns the preferred IP address for tmux status bar
# Priority: VPN interfaces first, then primary network interface

get_ip_for_interface() {
    local iface=$1
    ip -o -4 addr show dev "$iface" 2>/dev/null | awk '{print $4}' | cut -d'/' -f1
}

# Interface preference order: VPN first, then primary
get_preferred_interface() {
    local interfaces=("tun0" "wg0" "enp7s0" "eth0")
    for iface in "${interfaces[@]}"; do
        if ip -o -4 addr show dev "$iface" &>/dev/null; then
            echo "$iface"
            return
        fi
    done
    echo ""
}

preferred_iface=$(get_preferred_interface)
if [[ -n "$preferred_iface" ]]; then
    ip=$(get_ip_for_interface "$preferred_iface")
    if [[ -n "$ip" ]]; then
        echo "$preferred_iface: $ip"
        exit 0
    fi
fi

echo "No IP"
