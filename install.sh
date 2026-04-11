#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dotfiles install.sh — OpenSUSE Tumbleweed
#  Kullanım: bash install.sh [--dry-run]
# ─────────────────────────────────────────────────────────────

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false

# ── Argüman kontrolü ─────────────────────────────────────────
for arg in "$@"; do
    [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

# ── Renkler ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; RESET='\033[0m'

info()    { echo -e "${BLUE}[INFO]${RESET}  $*"; }
ok()      { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*"; }

# ── Dry-run wrapper ───────────────────────────────────────────
run() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} $*"
    else
        "$@"
    fi
}

# ─────────────────────────────────────────────────────────────
echo ""
echo "  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗"
echo "  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝"
echo "  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗"
echo "  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║"
echo "  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║"
echo "  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝"
echo ""
$DRY_RUN && warn "DRY-RUN modu aktif — hiçbir şey değiştirilmeyecek"
echo ""

# ─────────────────────────────────────────────────────────────
#  1. Gerekli paketleri kur
# ─────────────────────────────────────────────────────────────
info "Gerekli paketler kontrol ediliyor..."

PACKAGES=(stow git helix btop lolcat)
MISSING=()

for pkg in "${PACKAGES[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        MISSING+=("$pkg")
    fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
    warn "Eksik paketler: ${MISSING[*]}"
    run sudo zypper install -y "${MISSING[@]}" || warn "Bazı paketler kurulamadı, devam ediliyor..."
else
    ok "Tüm paketler mevcut"
fi

# ─────────────────────────────────────────────────────────────
#  2. Stow ile symlink'leri kur
# ─────────────────────────────────────────────────────────────
info "Symlink'ler oluşturuluyor (stow)..."

STOW_PACKAGES=(bash helix gtk)

for pkg in "${STOW_PACKAGES[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
        run stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$pkg" \
            && ok "stow: $pkg" \
            || warn "stow: $pkg başarısız oldu (çakışma olabilir)"
    else
        warn "Klasör bulunamadı: $pkg, atlanıyor"
    fi
done

# ─────────────────────────────────────────────────────────────
#  3. DNS — systemd-resolved
# ─────────────────────────────────────────────────────────────
info "DNS (systemd-resolved) ayarlanıyor..."

DNS_SRC="$DOTFILES_DIR/dns/etc/systemd/resolved.conf"
DNS_DEST="/etc/systemd/resolved.conf"

if [[ -f "$DNS_SRC" ]]; then
    run sudo cp "$DNS_SRC" "$DNS_DEST"
    run sudo systemctl enable --now systemd-resolved

    # /etc/resolv.conf → systemd stub
    if [[ ! -L /etc/resolv.conf ]] || [[ "$(readlink /etc/resolv.conf)" != "/run/systemd/resolve/stub-resolv.conf" ]]; then
        run sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
        ok "resolv.conf → systemd stub bağlandı"
    fi

    run sudo systemctl restart systemd-resolved
    ok "DNS ayarları uygulandı"
else
    warn "DNS config bulunamadı, atlanıyor"
fi

# ─────────────────────────────────────────────────────────────
#  4. GNOME dark mode (dconf)
# ─────────────────────────────────────────────────────────────
info "GNOME dark mode ayarlanıyor..."

if command -v gsettings &>/dev/null; then
    run gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    run gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    ok "GNOME dark mode aktif"
else
    warn "gsettings bulunamadı, GNOME ayarları atlandı"
fi

# ─────────────────────────────────────────────────────────────
#  5. adw-gtk3 tema paketi (GTK3 için)
# ─────────────────────────────────────────────────────────────
if ! rpm -q adw-gtk3-theme &>/dev/null 2>&1; then
    info "adw-gtk3-theme kuruluyor..."
    run sudo zypper install -y adw-gtk3-theme || warn "adw-gtk3-theme kurulamadı"
else
    ok "adw-gtk3-theme zaten kurulu"
fi

# ─────────────────────────────────────────────────────────────
echo ""
ok "Kurulum tamamlandı! 🎉"
echo ""
echo "  Sonraki adım: yeni bir terminal aç ya da:"
echo "    source ~/.bashrc"
echo ""
echo "  DNS'i doğrulamak için:"
echo "    resolvectl status"
echo "    resolvectl query cloudflare.com"
echo ""
