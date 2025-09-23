RESOLVED_CONF_PATH_TO="/etc/systemd/resolved.conf.d/"
RESOLVED_CONF="/etc/systemd/resolved.conf.d/fluffy.conf"
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
sudo mkdir -p $RESOLVED_CONF_PATH_TO
echo "$NEW_CONFIG" | sudo tee "$RESOLVED_CONF" > /dev/null
sudo systemctl enable --now systemd-resolved
sudo systemctl restart systemd-resolved