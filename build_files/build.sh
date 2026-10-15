#!/bin/bash
# ─────────────────────────────────────────────────────────────
#  Sfera OS — personalizzazioni applicate sopra la base Fedora
# ─────────────────────────────────────────────────────────────
set -ouex pipefail

### 1. Identità del sistema ###################################
# Il nome mostrato all'avvio, nelle impostazioni e nei programmi.
# L'ID resta "fedora" per restare compatibili con i pacchetti.
sed -i \
  -e 's/^NAME=.*/NAME="Sfera OS"/' \
  -e 's/^PRETTY_NAME=.*/PRETTY_NAME="Sfera OS (prototipo)"/' \
  -e 's/^VARIANT=.*/VARIANT="Prototipo"/' \
  -e 's/^VARIANT_ID=.*/VARIANT_ID=prototipo/' \
  /usr/lib/os-release

### 2. Programmi di sistema ###################################
# Strumento per mostrare le informazioni del sistema da terminale.
dnf5 -y install fastfetch

### 3. Catalogo app ##########################################
# Flathub come catalogo di app in sandbox, attivo di default.
mkdir -p /etc/flatpak/remotes.d
curl --retry 3 -fsSLo /etc/flatpak/remotes.d/flathub.flatpakrepo \
  https://dl.flathub.org/repo/flathub.flatpakrepo

### 4. Gestione delle risorse #################################
# Memoria compressa (zram): Fedora la attiva già; qui la portiamo
# a metà della RAM, massimo 8 GB, per i PC con poca memoria.
mkdir -p /usr/lib/systemd/zram-generator.conf.d
cat > /usr/lib/systemd/zram-generator.conf.d/50-sfera.conf <<'EOF'
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
EOF

### 5. Identità grafica #######################################
B=/ctx/branding

# Logo del sistema (impostazioni, informazioni sul sistema, installer)
install -Dm644 "$B/sfera-logo.svg"  /usr/share/icons/hicolor/scalable/apps/sfera-logo.svg
install -Dm644 "$B/sfera-icona.png" /usr/share/icons/hicolor/256x256/apps/sfera-logo.png
install -Dm644 "$B/sfera-icona.png" /usr/share/pixmaps/sfera-logo.png
if grep -q '^LOGO=' /usr/lib/os-release; then
  sed -i 's/^LOGO=.*/LOGO=sfera-logo/' /usr/lib/os-release
else
  echo 'LOGO=sfera-logo' >> /usr/lib/os-release
fi

# Sfondo del desktop
install -Dm644 "$B/sfera-sfondo.png" /usr/share/wallpapers/Sfera/contents/images/3840x2160.png
cat > /usr/share/wallpapers/Sfera/metadata.json <<'EOF'
{"KPlugin": {"Id": "Sfera", "Name": "Sfera", "Authors": [{"Name": "Sfera OS"}], "License": "CC-BY-SA-4.0"}}
EOF

# Schema di colori "Sfera Scuro" (ciano su blu notte)
install -Dm644 "$B/SferaScuro.colors" /usr/share/color-schemes/SferaScuro.colors

# Applica sfondo, colori e accento al primo accesso di ogni utente
install -Dm755 "$B/sfera-primo-accesso" /usr/libexec/sfera-primo-accesso
install -Dm644 "$B/sfera-primo-accesso.desktop" /etc/xdg/autostart/sfera-primo-accesso.desktop

# Schermata di avvio (Plymouth): logo Sfera su nero profondo
if [ -d /usr/share/plymouth/themes/spinner ]; then
  T=/usr/share/plymouth/themes/sfera
  mkdir -p "$T"
  cp -a /usr/share/plymouth/themes/spinner/. "$T/"
  rm -f "$T/spinner.plymouth"
  install -m644 "$B/sfera-avvio.png" "$T/watermark.png"
  cat > "$T/sfera.plymouth" <<'EOF'
[Plymouth Theme]
Name=Sfera
Description=Schermata di avvio di Sfera OS
ModuleName=two-step

[two-step]
ImageDir=/usr/share/plymouth/themes/sfera
DialogHorizontalAlignment=.5
DialogVerticalAlignment=.75
TitleHorizontalAlignment=.5
TitleVerticalAlignment=.382
HorizontalAlignment=.5
VerticalAlignment=.72
WatermarkHorizontalAlignment=.5
WatermarkVerticalAlignment=.45
Transition=none
TransitionDuration=0.0
BackgroundStartColor=0x05080c
BackgroundEndColor=0x05080c
UseFirmwareBackground=false
EOF
  plymouth-set-default-theme sfera

  # La schermata di avvio vive nell'initramfs: va rigenerato
  KVER="$(ls /usr/lib/modules | sort -V | tail -n1)"
  dracut --no-hostonly --kver "$KVER" --reproducible --add ostree \
    -f "/usr/lib/modules/$KVER/initramfs.img"
  chmod 0600 "/usr/lib/modules/$KVER/initramfs.img"
fi

### 6. Spazio per le prossime fasi ############################
# Qui verranno aggiunti: la shell Sfera, il servizio AI di sistema,
# il gestore risorse per Spazi e le app native.

dnf5 clean all
