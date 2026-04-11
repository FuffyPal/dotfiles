# dotfiles — OpenSUSE Tumbleweed

Kişisel sistem konfigürasyonları. **GNU Stow** ile symlink yönetimi.

## Yapı

```
dotfiles/
├── bash/           → ~/.bashrc
├── helix/          → ~/.config/helix/config.toml
├── gtk/            → ~/.config/gtk-3.0 & gtk-4.0
├── dns/            → /etc/systemd/resolved.conf
└── install.sh      → bootstrap scripti
```

## Kurulum

```bash
git clone https://github.com/KULLANICI_ADI/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

Sadece ne yapılacağını görmek için:
```bash
bash install.sh --dry-run
```

## Özellikler

| Başlık | Detay |
|---|---|
| Shell | bash — renkli prompt, history dedup |
| Editor | Helix (`hx`) — adwaita-dark tema |
| DNS | Cloudflare 1.1.1.1 + Quad9 9.9.9.9, DoT + DNSSEC + cache |
| Tema | GNOME Adwaita Dark, adw-gtk3 |

## DNS Doğrulama

```bash
resolvectl status
resolvectl query cloudflare.com
```

## Symlink'leri yenile

```bash
cd ~/.dotfiles
stow --restow bash helix gtk
```
