if [ ! -f "/etc/systemd/resolved.conf" ]; then
    echo "Error: unsupport or systemd-resolved not install. Error:/etc/systemd/resolved.conf not found"
    exit 1
fi
echo "u continue"
read -p "y/n " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
  echo "
    RESOLVED_CONF='/etc/systemd/resolved.conf'
    NEW_CONFIG='
    [Resolve]
    DNS=1.1.1.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net
    FallbackDNS=1.0.0.1#cloudflare-dns.com 149.112.112.112#dns.quad9.net
    Domains=
    DNSSEC=yes
    DNSOverTLS=yes
    MulticastDNS=no
    LLMNR=no
    Cache=yes
    CacheFromLocalhost=no
    DNSStubListener=yes
    DNSStubListenerExtra=
    ReadEtcHosts=yes
    ResolveUnicastSingleLabel=no
    StaleRetentionSec=0
    '
    sudo cp '$RESOLVED_CONF' '$RESOLVED_CONF.bak'
    echo '$NEW_CONFIG' | sudo tee '$RESOLVED_CONF' > /dev/null
    sudo systemctl restart systemd-resolved
    sudo systemctl enable --now systemd-resolved
    "
    read -p "y/n " twochoice
    twochoice=$(echo "$twochoice" | tr '[:upper:]' '[:lower:]')
    if [[ "$twochoice" == "y" || "$twochoice" == "yes" ]]; then
      RESOLVED_CONF="/etc/systemd/resolved.conf"
      NEW_CONFIG="
[Resolve]
DNS=1.1.1.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net
FallbackDNS=1.0.0.1#cloudflare-dns.com 149.112.112.112#dns.quad9.net
Domains=
DNSSEC=yes
DNSOverTLS=yes
MulticastDNS=no
LLMNR=no
Cache=yes
CacheFromLocalhost=no
DNSStubListener=yes
DNSStubListenerExtra=
ReadEtcHosts=yes
ResolveUnicastSingleLabel=no
StaleRetentionSec=0
      "
      sudo cp "$RESOLVED_CONF" "$RESOLVED_CONF.bak"
      echo "$NEW_CONFIG" | sudo tee "$RESOLVED_CONF" > /dev/null
      sudo systemctl enable --now systemd-resolved
      sudo systemctl restart systemd-resolved
    else
      echo "okey tschüss"
      exit 1
    fi
elif [[ "$choice" == "n" || "$choice" == "no" ]]; then
    echo "Owwww okey tchüss ..."
    exit 1 
else
    echo "Please Y or N ..."
fi
