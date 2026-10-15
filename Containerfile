# ─────────────────────────────────────────────────────────────
#  Sfera OS — ricetta del sistema
#  Ogni volta che questo file (o build_files/) cambia, GitHub
#  ricostruisce automaticamente il sistema.
# ─────────────────────────────────────────────────────────────

# Contenitore di appoggio con gli script di costruzione
FROM scratch AS ctx
COPY build_files /

# Base di partenza: Fedora 44 immutabile con desktop KDE Plasma.
# Il desktop KDE è TEMPORANEO: verrà sostituito dalla shell Sfera
# (Spazi, tela infinita, barra comandi) nella Fase 1.
FROM quay.io/fedora/fedora-kinoite:44

# Applica le personalizzazioni di Sfera OS
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=tmpfs,dst=/tmp \
    bash /ctx/build.sh

# Controllo finale: verifica che l'immagine sia un sistema avviabile valido
RUN bootc container lint
