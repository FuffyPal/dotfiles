#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  flatpak.sh — Flatpak Uygulama Kurucusu (--user)
#  Kullanım: bash flatpak.sh [--dry-run]
# ─────────────────────────────────────────────────────────────

set -euo pipefail

DRY_RUN=false
for arg in "$@"; do
    [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; RESET='\033[0m'

info() { echo -e "${BLUE}[INFO]${RESET}  $*"; }
ok()   { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn() { echo -e "${YELLOW}[WARN]${RESET}  $*"; }

echo ""
echo -e "${CYAN}  ░█▀▀░█░░░█▀█░▀█▀░█▀█░█▀█░█░█${RESET}"
echo -e "${CYAN}  ░█▀▀░█░░░█▀█░░█░░█▀▀░█▀█░█▀▄${RESET}"
echo -e "${CYAN}  ░▀░░░▀▀▀░▀░▀░░▀░░▀░░░▀░▀░▀░▀${RESET}"
echo -e "  Flatpak Uygulama Kurucusu — --user modu"
echo ""
$DRY_RUN && warn "DRY-RUN modu — hiçbir şey kurulmayacak"
echo ""

# ─────────────────────────────────────────────────────────────
#  1. flatpak kurulu mu kontrol et
# ─────────────────────────────────────────────────────────────
if ! command -v flatpak &>/dev/null; then
    warn "flatpak bulunamadı! Önce kurun: sudo zypper install flatpak"
    exit 1
fi

# ─────────────────────────────────────────────────────────────
#  2. Flathub user remote ekle
# ─────────────────────────────────────────────────────────────
info "Flathub user remote kontrol ediliyor..."
if $DRY_RUN; then
    echo -e "${YELLOW}[DRY-RUN]${RESET} flatpak --user remote-add --if-not-exists flathub_user https://dl.flathub.org/repo/flathub.flatpakrepo"
else
    flatpak --user remote-add --if-not-exists flathub_user \
        https://dl.flathub.org/repo/flathub.flatpakrepo \
        && ok "flathub_user remote hazır" \
        || warn "Remote eklenemedi (zaten var olabilir)"
fi

# ─────────────────────────────────────────────────────────────
#  3. Uygulama listesi
# ─────────────────────────────────────────────────────────────
APPS=(
    # Medya
    com.github.rafostar.Clapper          # Video oynatıcı (GTK4/native)

    # Dosya paylaşım
    org.localsend.localsend_app          # LocalSend — LAN paylaşım

    # Görsel araçlar
    io.gitlab.theevilskeleton.Upscaler   # AI görüntü büyütücü
    org.gnome.Loupe                      # Resim görüntüleyici (GNOME native)

    # Sistem araçları
    com.github.tchx84.Flatseal           # Flatpak izin yöneticisi
    com.mattjakeman.ExtensionManager     # GNOME extension yöneticisi
    io.github.dvlv.boxbuddyrs            # Toolbox/Distrobox GUI
    io.podman_desktop.PodmanDesktop      # Podman container GUI
    com.usebottles.bottles               # Windows uygulamaları (Wine)

    # İletişim
    org.mozilla.Thunderbird              # E-posta istemcisi
    dev.vencord.Vesktop                  # Discord (Vencord modded)

    # Tarayıcı
    app.zen_browser.zen                  # Zen Browser (Firefox tabanlı)

    # Güvenlik & Gizlilik
    org.torproject.torbrowser-launcher   # Tor Browser
    io.ente.auth                         # 2FA authenticator

    # Ofis
    org.libreoffice.LibreOffice          # LibreOffice suite

    # Ses
    com.github.wwmm.easyeffects         # Ses efektleri (EQ, compressor)
)

# ─────────────────────────────────────────────────────────────
#  4. Kur
# ─────────────────────────────────────────────────────────────
TOTAL=${#APPS[@]}
DONE=0
FAILED=()

info "Toplam $TOTAL uygulama kurulacak (--user)"
echo ""

for app in "${APPS[@]}"; do
    # Yorum satırlarını atla (# ile başlayanlar array'e girmez zaten ama güvenlik için)
    [[ "$app" == \#* ]] && continue

    DONE=$((DONE + 1))
    echo -e "${CYAN}[$DONE/$TOTAL]${RESET} $app"

    if $DRY_RUN; then
        echo -e "  ${YELLOW}[DRY-RUN]${RESET} flatpak install --user -y flathub_user $app"
        continue
    fi

    # Zaten kurulu mu?
    if flatpak list --user --app --columns=application 2>/dev/null | grep -q "^${app}$"; then
        ok "  Zaten kurulu, atlanıyor"
        continue
    fi

    flatpak install --user -y flathub_user "$app" 2>/dev/null \
        && ok "  Kuruldu" \
        || { warn "  Kurulamadı: $app"; FAILED+=("$app"); }

    echo ""
done

# ─────────────────────────────────────────────────────────────
#  5. Özet
# ─────────────────────────────────────────────────────────────
echo ""
ok "Flatpak kurulumu tamamlandı! 🎉"

if [[ ${#FAILED[@]} -gt 0 ]]; then
    warn "Kurulamayan uygulamalar:"
    for f in "${FAILED[@]}"; do
        echo "    - $f"
    done
    echo ""
    echo "  Bunları manuel kurmak için:"
    echo "    flatpak install --user flathub_user <uygulama_id>"
fi

echo ""
echo "  Kurulu flatpak'ları görmek için:"
echo "    flatpak list --user"
echo ""