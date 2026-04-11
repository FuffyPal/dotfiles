#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dotfiles install.sh — OpenSUSE Tumbleweed
#  Kullanım: bash install.sh [--dry-run]
# ─────────────────────────────────────────────────────────────

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false

for arg in "$@"; do
    [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; RESET='\033[0m'

info()  { echo -e "${BLUE}[INFO]${RESET}  $*"; }
ok()    { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
step()  { echo -e "\n${CYAN}══ $* ${RESET}"; }

run() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} $*"
    else
        "$@"
    fi
}

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
step "1/8 — Temel paketleri kur"
# ─────────────────────────────────────────────────────────────
info "Paketler kontrol ediliyor..."

ZYPPER_PKGS=(stow git helix btop ruby)
MISSING_ZYPPER=()
for pkg in "${ZYPPER_PKGS[@]}"; do
    command -v "$pkg" &>/dev/null || MISSING_ZYPPER+=("$pkg")
done

if [[ ${#MISSING_ZYPPER[@]} -gt 0 ]]; then
    warn "Eksik paketler: ${MISSING_ZYPPER[*]}"
    run sudo zypper install -y "${MISSING_ZYPPER[@]}" \
        && ok "Paketler kuruldu" \
        || warn "Bazı paketler kurulamadı"
else
    ok "Temel paketler mevcut"
fi

# lolcat — OpenSUSE deposunda yok, gem ile kurulur
if ! command -v lolcat &>/dev/null; then
    info "lolcat gem ile kuruluyor..."
    run sudo gem install lolcat \
        && ok "lolcat kuruldu (/usr/local/bin/lolcat)" \
        || warn "lolcat kurulamadı"
else
    ok "lolcat zaten mevcut"
fi

# ─────────────────────────────────────────────────────────────
step "2/8 — Stow ile symlink'leri kur"
# ─────────────────────────────────────────────────────────────
info "Symlink'ler oluşturuluyor..."

for pkg in bash helix gtk; do
    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
        warn "Klasör bulunamadı: $pkg, atlanıyor"
        continue
    fi

    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} stow --dir=$DOTFILES_DIR --target=$HOME --restow $pkg"
        continue
    fi

    # Çakışan dosyaları yedekle
    while IFS= read -r line; do
        conflict=$(echo "$line" | grep -oP "(?<=existing target is not owned by stow: ).*" || true)
        [[ -z "$conflict" ]] && continue
        target="$HOME/$conflict"
        if [[ -f "$target" && ! -L "$target" ]]; then
            mv "$target" "${target}.bak.$(date +%s)"
            warn "  Yedeklendi: $target"
        fi
    done < <(stow --dir="$DOTFILES_DIR" --target="$HOME" --no --restow "$pkg" 2>&1 || true)

    stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$pkg" \
        && ok "stow: $pkg" \
        || warn "stow: $pkg başarısız"
done

# ─────────────────────────────────────────────────────────────
step "3/8 — systemd-resolved kur ve yapılandır"
# ─────────────────────────────────────────────────────────────
info "systemd-resolved kontrol ediliyor..."

# systemd-resolved TW minimal kurulumda eksik olabilir
if ! systemctl list-unit-files 2>/dev/null | grep -q "systemd-resolved"; then
    warn "systemd-resolved servis bulunamadı, kuruluyor..."
    run sudo zypper install -y systemd-network || true
fi

DNS_SRC="$DOTFILES_DIR/dns/etc/systemd/resolved.conf"
if [[ -f "$DNS_SRC" ]]; then
    run sudo cp "$DNS_SRC" /etc/systemd/resolved.conf
    run sudo systemctl enable --now systemd-resolved

    if [[ ! -L /etc/resolv.conf ]] || \
       [[ "$(readlink /etc/resolv.conf 2>/dev/null)" != "/run/systemd/resolve/stub-resolv.conf" ]]; then
        run sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
        ok "resolv.conf → systemd stub bağlandı"
    fi

    run sudo systemctl restart systemd-resolved
    ok "DNS ayarları uygulandı (Cloudflare DoT + DNSSEC + cache)"
else
    warn "DNS config bulunamadı: $DNS_SRC"
fi

# ─────────────────────────────────────────────────────────────
step "4/8 — GNOME dark mode + adw-gtk3"
# ─────────────────────────────────────────────────────────────
if command -v gsettings &>/dev/null; then
    run gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    run gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    ok "GNOME dark mode aktif"
else
    warn "gsettings bulunamadı"
fi

if ! rpm -q adw-gtk3-theme &>/dev/null 2>&1; then
    run sudo zypper install -y adw-gtk3-theme \
        && ok "adw-gtk3-theme kuruldu" \
        || warn "adw-gtk3-theme kurulamadı"
else
    ok "adw-gtk3-theme zaten kurulu"
fi

# ─────────────────────────────────────────────────────────────
step "5/8 — VSCode"
# ─────────────────────────────────────────────────────────────
if command -v code &>/dev/null; then
    ok "VSCode zaten kurulu"
else
    info "VSCode kuruluyor (Microsoft repo)..."
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} Microsoft GPG key + repo + zypper install code"
    else
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 2>/dev/null || true
        cat <<'REPO' | sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null
[vscode]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
REPO
        sudo zypper refresh --repo vscode
        sudo zypper install -y code \
            && ok "VSCode kuruldu" \
            || warn "VSCode kurulamadı — manuel: https://code.visualstudio.com"
    fi
fi

# ─────────────────────────────────────────────────────────────
step "6/8 — Steam"
# ─────────────────────────────────────────────────────────────
if command -v steam &>/dev/null || rpm -q steam &>/dev/null 2>&1; then
    ok "Steam zaten kurulu"
else
    info "Steam kuruluyor (games repo)..."
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} games repo ekleme + zypper install steam"
    else
        sudo zypper addrepo --refresh \
            "https://download.opensuse.org/repositories/games/openSUSE_Tumbleweed/" \
            games 2>/dev/null || true
        sudo zypper refresh --repo games
        sudo zypper install -y steam \
            && ok "Steam kuruldu" \
            || {
                warn "games repo'dan kurulamadı, Flatpak deneniyor..."
                flatpak --user install -y flathub_user com.valvesoftware.Steam \
                    && ok "Steam Flatpak olarak kuruldu" \
                    || warn "Steam kurulamadı"
            }
    fi
fi

# ─────────────────────────────────────────────────────────────
step "7/8 — Flatpak uygulamaları"
# ─────────────────────────────────────────────────────────────
FLATPAK_SCRIPT="$DOTFILES_DIR/scripts/flatpak.sh"
if [[ -f "$FLATPAK_SCRIPT" ]]; then
    if $DRY_RUN; then
        bash "$FLATPAK_SCRIPT" --dry-run
    else
        bash "$FLATPAK_SCRIPT" && ok "Flatpak uygulamaları kuruldu"
    fi
else
    warn "flatpak.sh bulunamadı: $FLATPAK_SCRIPT"
fi

# ─────────────────────────────────────────────────────────────
step "8/8 — .bashrc yükle"
# ─────────────────────────────────────────────────────────────
[[ -f "$HOME/.bashrc" ]] && run source "$HOME/.bashrc" 2>/dev/null || true
ok ".bashrc hazır"

# ─────────────────────────────────────────────────────────────
echo ""
ok "Kurulum tamamlandı! 🎉"
echo ""
echo "  Yeni terminal aç ya da:  source ~/.bashrc"
echo "  DNS doğrula:             resolvectl status"
echo "  Kilitleri gör:           sudo zypper locks"
echo ""