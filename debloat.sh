#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  debloat.sh — OpenSUSE Tumbleweed GNOME
#  Kullanım: bash debloat.sh [--dry-run]
#
#  ÖNEMLİ: Bu script paketleri sildikten sonra ilgili
#  pattern'ları da kaldırır ve zypper lock ekler.
#  Böylece "sudo zypper install-new-recommends" çalıştırsan
#  bile bu paketler geri dönmez.
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

# Paketi sil — sadece kurulu olanları sil, yoksa sessizce geç
remove() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} sudo zypper remove -y --clean-deps $*"
        return
    fi
    local to_remove=()
    for pkg in "$@"; do
        rpm -q "$pkg" &>/dev/null && to_remove+=("$pkg")
    done
    if [[ ${#to_remove[@]} -gt 0 ]]; then
        sudo zypper remove -y --clean-deps "${to_remove[@]}" 2>/dev/null \
            && ok "Silindi: ${to_remove[*]}" \
            || warn "Silinemedi: ${to_remove[*]}"
    else
        info "Zaten kurulu değil: $*"
    fi
}

# Paketi zypper lock ile kilitle (install-new-recommends'e karşı)
lock() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN]${RESET} sudo zypper addlock $*"
        return
    fi
    for pkg in "$@"; do
        sudo zypper addlock "$pkg" &>/dev/null || true
    done
    ok "Kilitlendi: $*"
}

echo ""
echo -e "${CYAN}  ░█▀▄░█▀▀░█▀▄░█░░░█▀█░█▀█░▀█▀${RESET}"
echo -e "${CYAN}  ░█░█░█▀▀░█▀▄░█░░░█░█░█▀█░░█░${RESET}"
echo -e "${CYAN}  ░▀▀░░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀░▀░░▀░${RESET}"
echo -e "  OpenSUSE Tumbleweed — GNOME Debloat"
echo ""
$DRY_RUN && warn "DRY-RUN modu — hiçbir şey değiştirilmeyecek"
echo ""

# ─────────────────────────────────────────────────────────────
step "1/8 — Pattern'ları kaldır (install-new-recommends koruması)"
# ─────────────────────────────────────────────────────────────
# KRİTİK ADIM: Pattern'lar kaldırılmadan paketler silinse bile
# "zypper install-new-recommends" onları geri kurar!
info "Gereksiz pattern'lar kaldırılıyor..."
remove \
    patterns-gnome-gnome_games \
    patterns-gnome-gnome_imaging \
    patterns-gnome-gnome_internet \
    patterns-gnome-gnome_office \
    patterns-gnome-gnome_multimedia \
    patterns-gnome-sw_management_gnome \
    patterns-yast-x11_yast \
    patterns-yast-yast2_basis \
    patterns-base-documentation \
    patterns-office-office \
    patterns-desktop-imaging \
    patterns-desktop-multimedia

ok "Pattern'lar temizlendi"

# ─────────────────────────────────────────────────────────────
step "2/8 — GNOME Oyunları"
# ─────────────────────────────────────────────────────────────
remove \
    gnome-chess gnome-chess-lang gnuchess \
    gnome-mahjongg gnome-mahjongg-lang \
    gnome-mines gnome-mines-lang \
    gnome-sudoku gnome-sudoku-lang \
    iagno iagno-lang \
    quadrapassel quadrapassel-lang \
    swell-foop swell-foop-lang \
    lightsoff lightsoff-lang

lock gnome-chess gnuchess gnome-mahjongg gnome-mines gnome-sudoku \
     iagno quadrapassel swell-foop lightsoff
ok "Oyunlar temizlendi ve kilitlendi"

# ─────────────────────────────────────────────────────────────
step "3/8 — İstenmeyen GNOME Uygulamaları"
# ─────────────────────────────────────────────────────────────
remove \
    evolution evolution-lang \
    evolution-ews evolution-ews-lang \
    gnome-contacts gnome-contacts-lang \
    gnome-clocks gnome-clocks-lang \
    gnome-maps gnome-maps-lang \
    simple-scan simple-scan-lang \
    gnome-connections gnome-connections-lang \
    gnome-photos gnome-photos-lang \
    snapshot snapshot-lang \
    gnome-calculator gnome-calculator-lang \
    gnome-shell-search-provider-gnome-calculator \
    gnome-shell-search-provider-gnome-clocks \
    gnome-shell-search-provider-gnome-photos \
    gnome-shell-search-provider-contacts \
    gnome-tour gnome-tour-data gnome-tour-lang \
    gnome-music gnome-music-lang \
    gnome-extensions \
    opensuse-welcome opensuse-welcome-lang opensuse-welcome-launcher

lock evolution gnome-contacts gnome-clocks gnome-maps simple-scan \
     gnome-connections gnome-photos snapshot gnome-calculator \
     gnome-tour gnome-music gnome-extensions opensuse-welcome
ok "GNOME uygulamaları temizlendi ve kilitlendi"

# ─────────────────────────────────────────────────────────────
step "4/8 — Firefox"
# ─────────────────────────────────────────────────────────────
remove MozillaFirefox MozillaFirefox-translations-common mozilla-openh264
lock MozillaFirefox
ok "Firefox temizlendi ve kilitlendi"

# ─────────────────────────────────────────────────────────────
step "5/8 — Evince (PDF Görüntüleyici)"
# ─────────────────────────────────────────────────────────────
remove evince evince-lang evince-plugin-pdfdocument
lock evince
ok "Evince temizlendi ve kilitlendi"

# ─────────────────────────────────────────────────────────────
step "6/8 — Totem (Video Oynatıcı)"
# ─────────────────────────────────────────────────────────────
# totem-video-thumbnailer BIRAKILDI (Nautilus thumbnail için gerekli)
remove totem totem-lang totem-plugins
lock totem
ok "Totem temizlendi ve kilitlendi"

# ─────────────────────────────────────────────────────────────
step "7/8 — LibreOffice RPM (Flatpak versiyonu flatpak.sh ile gelecek)"
# ─────────────────────────────────────────────────────────────
remove \
    libreoffice libreoffice-base libreoffice-calc libreoffice-draw \
    libreoffice-filters-optional libreoffice-gnome libreoffice-gtk3 \
    libreoffice-icon-themes libreoffice-impress libreoffice-math \
    libreoffice-pyuno libreoffice-writer libreoffice-branding-openSUSE \
    libreoffice-share-linker libreoffice-mailmerge libreofficekit \
    libreoffice-l10n-de libreoffice-l10n-en

lock libreoffice
ok "LibreOffice RPM temizlendi (Flatpak versiyonu gelecek)"

# ─────────────────────────────────────────────────────────────
step "8/8 — YaST"
# ─────────────────────────────────────────────────────────────
remove \
    yast2 yast2-control-center yast2-control-center-qt \
    yast2-core yast2-hardware-detection yast2-logs \
    yast2-perl-bindings yast2-pkg-bindings \
    yast2-ruby-bindings yast2-snapper \
    yast2-qt-branding-openSUSE yast2-ycp-ui-bindings \
    yast2-alternatives yast2-bootloader yast2-firewall \
    yast2-metapackage-handler yast2-network yast2-packager \
    yast2-proxy yast2-storage-ng yast2-theme yast2-transfer \
    yast2-vm yast2-xml yast2-country-data \
    libyui-ncurses-pkg16 libstorage-ng1 libstorage-ng-lang \
    libstorage-ng-ruby ruby4.0-rubygem-cfa_grub2

lock yast2
ok "YaST temizlendi ve kilitlendi"

# ─────────────────────────────────────────────────────────────
echo ""
ok "Debloat tamamlandı! 🎉"
echo ""
echo "  Aktif kilitleri görmek için:"
echo "    sudo zypper locks"
echo ""
echo "  Bir kilidi kaldırmak için:"
echo "    sudo zypper removelock <paket_adı>"
echo ""
echo "  Artık kullanılmayan bağımlılıkları bulmak için:"
echo -e "  ${CYAN}  sudo zypper packages --unneeded${RESET}"
echo ""