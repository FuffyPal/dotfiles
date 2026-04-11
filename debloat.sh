#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  debloat.sh — OpenSUSE Tumbleweed GNOME
#  Kullanım: bash debloat.sh [--dry-run]
#
#  ÖNEMLİ NOTLAR:
#  • zypper'ın bağımlılık çözümleme motoru çakışma varsa
#    sizi uyarır ve onay ister — bu normal.
#  • --dry-run ile önce ne olacağını görebilirsiniz.
# ─────────────────────────────────────────────────────────────

set -euo pipefail

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

run_zypper() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} sudo zypper remove -y --clean-deps $*"
    else
        sudo zypper remove -y --clean-deps "$@" 2>/dev/null || \
            warn "Bazı paketler zaten yok ya da kaldırılamadı: $*"
    fi
}

echo ""
echo -e "${CYAN}  ░█▀▄░█▀▀░█▀▄░█░░░█▀█░█▀█░▀█▀${RESET}"
echo -e "${CYAN}  ░█░█░█▀▀░█▀▄░█░░░█░█░█▀█░░█░${RESET}"
echo -e "${CYAN}  ░▀▀░░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀░▀░░▀░${RESET}"
echo -e "  OpenSUSE Tumbleweed — GNOME Debloat"
echo ""
$DRY_RUN && warn "DRY-RUN modu — hiçbir şey silinmeyecek"
echo ""

# ─────────────────────────────────────────────────────────────
step "1/7 — GNOME Oyunları"
# ─────────────────────────────────────────────────────────────
GAMES=(
    gnome-chess          # Satranç
    gnuchess             # gnome-chess 
    gnome-mahjongg       # Mahjong
    gnome-mines          # mines 
    gnome-sudoku         # Sudoku
    iagno                # Reversi
    quadrapassel         # Tetris
    swell-foop           # Swell Foop
    lightsoff            # Listende 
)
info "Siliniyor: ${GAMES[*]}"
run_zypper "${GAMES[@]}"
ok "Oyunlar temizlendi"

# ─────────────────────────────────────────────────────────────
step "2/7 — İstenmeyen GNOME Uygulamaları"
# ─────────────────────────────────────────────────────────────

# Evolution — e-posta istemcisi
# NOT: evolution-data-server burada SİLİNMİYOR çünkü
# gnome-online-accounts, gnome-calendar (shell entegrasyonu)
# ve seahorse buna bağımlı. Sadece arayüzü siliyoruz.
APPS=(
    evolution
    evolution-ews          # Exchange extension
    evolution-lang
    evolution-ews-lang
    gnome-contacts         
    gnome-contacts-lang
    gnome-clocks           
    gnome-clocks-lang
    gnome-maps             
    gnome-maps-lang
    simple-scan            
    simple-scan-lang
    gnome-connections      
    gnome-connections-lang
    gnome-photos          
    gnome-photos-lang
    snapshot               
    snapshot-lang
    gnome-calculator       
    gnome-calculator-lang
    gnome-shell-search-provider-gnome-calculator
    gnome-shell-search-provider-gnome-clocks
    gnome-shell-search-provider-gnome-photos
    gnome-shell-search-provider-contacts
    gnome-tour
)
info "Siliniyor: GNOME uygulamaları"
run_zypper "${APPS[@]}"
ok "Uygulamalar temizlendi"

# ─────────────────────────────────────────────────────────────
step "3/7 — Evince (PDF Görüntüleyici)"
# ─────────────────────────────────────────────────────────────
# NOT: Eğer ileride farklı bir PDF görüntüleyici kurmayı
# planlıyorsan (örn. Flatpak Evince veya Okular) güvenle silebilirsin.
EVINCE=(
    evince
    evince-plugin-pdfdocument
    evince-lang
)
info "Siliniyor: Evince"
run_zypper "${EVINCE[@]}"
ok "Evince temizlendi"

# ─────────────────────────────────────────────────────────────
step "4/7 — Totem (Video Oynatıcı)"
# ─────────────────────────────────────────────────────────────
# totem-pl-parser ve totem-video-thumbnailer bırakılıyor
# çünkü Nautilus dosya küçük resimleri için kullanıyor.
TOTEM=(
    totem
    totem-lang
    totem-plugins
)
info "Siliniyor: Totem (oynatıcı + eklentiler)"
run_zypper "${TOTEM[@]}"
ok "Totem temizlendi"

# ─────────────────────────────────────────────────────────────
step "5/7 — Firefox (Browser)"
# ─────────────────────────────────────────────────────────────
FIREFOX=(
    MozillaFirefox
    MozillaFirefox-translations-common
)
info "Siliniyor: Totem (oynatıcı + eklentiler)"
run_zypper "${TOTEM[@]}"
ok "Totem temizlendi"

# ─────────────────────────────────────────────────────────────
step "6/7 — gnome-extensions (Flatpak ile değiştirilecek)"
# ─────────────────────────────────────────────────────────────
info "Siliniyor: gnome-extensions (RPM)"
run_zypper gnome-extensions
ok "gnome-extensions RPM kaldırıldı"

if ! $DRY_RUN; then
    info "Flatpak'tan gnome-extension-manager kuruluyor..."
    if command -v flatpak &>/dev/null; then
        flatpak install -y flathub com.mattjakeman.ExtensionManager 2>/dev/null \
            && ok "Extension Manager kuruldu" \
            || warn "Flatpak kurulumu başarısız — manuel kur: flatpak install flathub com.mattjakeman.ExtensionManager"
    else
        warn "flatpak bulunamadı"
    fi
fi

# ─────────────────────────────────────────────────────────────
step "7/7 — YaST"
# ─────────────────────────────────────────────────────────────
echo ""
warn "YaST KONUSUNDA UYARI:"
echo "  YaST, zypper ve sistem yönetim araçlarıyla entegre."
echo "  Silmek istiyorsan aşağıdaki komutu AYRI çalıştır:"
echo ""
echo -e "  ${YELLOW}sudo zypper remove -y --clean-deps \\"
echo "    yast2 yast2-control-center yast2-control-center-qt \\"
echo "    yast2-core yast2-hardware-detection yast2-logs \\"
echo "    yast2-perl-bindings yast2-pkg-bindings \\"
echo "    yast2-ruby-bindings yast2-snapper \\"
echo -e "    yast2-qt-branding-openSUSE yast2-ycp-ui-bindings${RESET}"
echo ""
warn "NOT: YaST silindikten sonra snapper-zypp-plugin etkilenebilir."
warn "Eğer snapper (BTRFS snapshot) kullanıyorsan dikkat et."

# ─────────────────────────────────────────────────────────────
echo ""
ok "Debloat tamamlandı! 🎉"
echo ""
echo "  Boşalan alanı görmek için:"
echo "    df -h /"
echo ""
echo "  Artık kullanılmayan bağımlılıkları temizlemek için:"
echo -e "  ${CYAN}  sudo zypper packages --unneeded${RESET}"
echo ""