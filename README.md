# dotfiles ~~(o)~~

My personal Ansible-based workstation setup for Fedora. Fresh install to fully configured in one command.

```
ansible-playbook --ask-vault-pass -K playbook.yml -i hosts.ini
```

---

## what it does

```
[1] debloat      -- removes gnome bloat, firefox, libreoffice and other garbage
[2] repos        -- RPM Fusion, Terra, NVIDIA, Chrome, VS Code, Antigravity
[3] install      -- git, podman, helix, rust, go, btop, steam, zed editor and more
[4] flatpak      -- sets up flathub and installs apps (vesktop, librewolf, bottles...)
[5] nvidia       -- auto-detects GPU and installs drivers + container toolkit
[6] dotfiles     -- copies bashrc, vimrc, gitconfig, helix config, dnf config
[7] wallpaper    -- sets wallpaper via gsettings (GNOME only)
[8] systemd      -- enables tailscaled
[9] ssh + gpg    -- deploys keys from vault (hostname: cutie only)
```

---

## structure

```
dotfiles/
|- assets/
|  |- wallpaper/       <- wallpaper files
|  |- avatar/
|- home/               <- user dotfiles (bashrc, vimrc, gitconfig, helix)
|- system/             <- system configs (dnf.conf, resolved.conf)
|- roles/              <- ansible task files
|- vars/
|  |- secrets.yml      <- ansible-vault encrypted (ssh + gpg keys)
|- hosts.ini
|- playbook.yml
```

---

## secrets setup

keys are stored encrypted in `vars/secrets.yml` via ansible-vault. never touch the disk unencrypted (except briefly in `/tmp` during GPG import).

create the vault file:

```bash
ansible-vault create vars/secrets.yml
```

format inside:

```yaml
ssh_private_key: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  ...
  -----END OPENSSH PRIVATE KEY-----

ssh_public_key: "ssh-rsa AAAA... user@host"

gpg_private_key: |
  -----BEGIN PGP PRIVATE KEY BLOCK-----
  ...
  -----END PGP PRIVATE KEY BLOCK-----
```

---

## requirements

- Fedora (tested on Fedora 44+)
- Ansible 2.20.6+
- hostname must be `cutie` for SSH/GPG/dotfiles tasks

```bash
sudo dnf install -y ansible
```

---

## running

full setup:

```bash
ansible-playbook --ask-vault-pass -K playbook.yml -i hosts.ini
```

single task:

```bash
ansible-playbook --ask-vault-pass -K playbook.yml -i hosts.ini --start-at-task "enable ssh key"
```

---

## notes

- NVIDIA driver install is automatic -- skipped if no GPU detected
- Flatpak apps install as user (no root)
- GPG import shows `rc=2` warning from gpg itself -- this is normal, key imports fine
- SSH keypair is deployed to `~/.ssh/id_rsa` + `id_rsa.pub` for GNOME Keyring compatibility

---

```
(^_^) works on my machine
```
