# Sfera OS

Sistema operativo open source basato su Linux, con interfaccia a Spazi, AI locale integrata e sicurezza per progettazione.

**Stato:** Fase 0 — prototipo. Per ora usa la base Fedora 44 immutabile con desktop KDE Plasma temporaneo, che verrà sostituito dalla shell Sfera.

## Cosa c'è in questa cartella

| File | A cosa serve |
| --- | --- |
| `Containerfile` | La ricetta del sistema: da quale base parte e cosa ci aggiunge |
| `build_files/build.sh` | Le personalizzazioni: nome, programmi, catalogo app, memoria, identità grafica |
| `build_files/branding/` | Logo, schermata di avvio, sfondo, schema di colori "Sfera Scuro" |
| `.github/workflows/build.yml` | Costruisce il sistema su GitHub a ogni modifica e ogni notte |
| `.github/workflows/build-iso.yml` | Crea il file ISO installabile, su richiesta |
| `disk_config/iso.toml` | Configurazione dell'installer |

---

## Guida: dalla cartella al primo avvio

### 1. Crea l'account GitHub

1. Vai su <https://github.com/signup> e registrati (gratis).
2. Conferma l'email e attiva la verifica in due passaggi quando te la propone.

### 2. Crea il repository del progetto

1. In alto a destra clicca **+** → **New repository**.
2. Nome: `sfera-os` (tutto minuscolo).
3. Scegli **Public**: è gratuito e serve per le ore di costruzione illimitate.
4. Non spuntare nessuna opzione (niente README, niente .gitignore).
5. Clicca **Create repository**.

### 3. Carica i file

1. Estrai lo ZIP che hai ricevuto sul computer.
2. Nella pagina del repository appena creato clicca il link **uploading an existing file**.
3. Apri la cartella `sfera-os` estratta, **seleziona tutto il contenuto** (comprese le cartelle `.github`, `build_files`, `disk_config`) e trascinalo nella pagina. Su Ubuntu la cartella `.github` è nascosta: nel programma File premi **Ctrl+H** per vederla.
4. In basso clicca **Commit changes**.
5. Controlla che nella pagina del repository compaia la cartella `.github`. Se manca, vedi "Problemi comuni" in fondo.

### 4. Attendi la prima costruzione

1. Apri la scheda **Actions** del repository.
2. Vedrai **Costruisci Sfera OS** in esecuzione (pallino giallo). Dura circa 10–20 minuti.
3. Quando diventa verde, il sistema è costruito e pubblicato.

### 5. Rendi pubblico il sistema

Serve perché i PC con Sfera OS installato possano scaricare gli aggiornamenti.

1. Vai sul tuo profilo GitHub → scheda **Packages** → **sfera-os**.
2. **Package settings** → in fondo, **Change visibility** → **Public**.

### 6. Crea il file ISO

1. Scheda **Actions** → a sinistra **Crea ISO di Sfera OS** → **Run workflow** → **Run workflow**.
2. Dura circa 20–30 minuti.
3. Quando è verde, apri l'esecuzione e in fondo, sotto **Artifacts**, scarica **sfera-os-iso** (circa 3–4 GB, resta disponibile 7 giorni).
4. Estrai lo ZIP scaricato: dentro c'è `sfera-os.iso`.

### 7. Prova Sfera OS in una macchina virtuale

Il modo più sicuro: non tocca il sistema del tuo PC.

**Su Ubuntu (consigliato: GNOME Boxes)**

1. Apri il Terminale e installa Boxes: `sudo apt install gnome-boxes`
2. Apri **Boxes** → pulsante **+** → **Crea una macchina virtuale** → **Seleziona un file** e scegli `sfera-os.iso`.
3. Se chiede il sistema, scegli **Fedora** (o "Sistema operativo sconosciuto").
4. Assegna almeno **4 GB di memoria** e **40 GB di disco**, poi **Crea**.
5. Segui l'installer (lingua, disco, utente) e riavvia la macchina virtuale.

**Su Windows: VirtualBox**

1. Installa **VirtualBox** da <https://www.virtualbox.org>.
2. **Nuova** → tipo **Linux**, versione **Fedora (64-bit)**, scegli `sfera-os.iso`.
3. Almeno **4 GB di RAM**, **2 processori**, disco da **40 GB**; in **Impostazioni → Sistema** attiva **EFI**.

Al primo accesso Sfera OS applica da solo sfondo, colori e accento ciano. La schermata con il logo si vede durante l'avvio.

---

## Come si modifica il sistema

Ogni modifica a `Containerfile` o `build_files/build.sh` fatta da GitHub (icona della matita → **Commit changes**) ricostruisce automaticamente il sistema. I PC già installati ricevono la nuova versione con il comando:

```
sudo bootc upgrade
```

e la applicano al riavvio. Se qualcosa non va, al riavvio si sceglie la versione precedente.

## Problemi comuni

- **La cartella `.github` non è stata caricata.** In alcuni sistemi le cartelle che iniziano con il punto sono nascoste. Nel repository clicca **Add file → Create new file**, scrivi come nome `.github/workflows/build.yml`, incolla il contenuto del file corrispondente e salva. Ripeti per `.github/workflows/build-iso.yml`.
- **La costruzione è rossa (errore).** Apri l'esecuzione, clicca sul passaggio con la X rossa e copia il messaggio di errore: si risolve partendo da lì.
- **"Crea ISO" fallisce subito al download dell'immagine.** Assicurati che "Costruisci Sfera OS" sia terminato con successo almeno una volta.

## Roadmap

- **Fase 0 · Fondamenta** — immagine installabile, nome, mockup ← *siamo qui*
- **Fase 1 · Sistema** — shell Sfera con Spazi, tela infinita, barra comandi, permessi, servizio AI locale
- **Fase 2 · App native** — file, note, posta, calendario, documenti, SDK pubblico
- **Fase 3 · Settori** — sostituzione del software di settore, un settore alla volta
