#!/usr/bin/env bash
# install-parrot-repo.sh
# Tambah repo & tools Parrot Security OS
set -euo pipefail

PARROT_SUITE="lory"
PARROT_LIST="/etc/apt/sources.list.d/parrot.list"
PARROT_PIN="/etc/apt/preferences.d/99parrot"

[[ $EUID -ne 0 ]] && { echo "Gunakan sudo atau root"; exit 1; }

# === Repo ===
if [[ ! -f "$PARROT_LIST" ]]; then
  cat > "$PARROT_LIST" <<EOF
deb-src https://deb.parrot.sh/parrot ${PARROT_SUITE} main contrib non-free non-free-firmware
deb-src https://deb.parrot.sh/parrot ${PARROT_SUITE}-security main contrib non-free non-free-firmware
deb-src https://deb.parrot.sh/parrot ${PARROT_SUITE}-backports main contrib non-free non-free-firmware
EOF
  echo "[+] Parrot repo ditambahkan"
fi

# === Key ===
if ! apt-key list 2>/dev/null | grep -qi parrot; then
  curl -fsSL https://deb.parrot.sh/parrot/mirrors/parrot.gpg -o /etc/apt/trusted.gpg.d/parrot-archive-keyring.gpg
  echo "[+] Imported Parrot key"
fi

# === Pinning ===
mkdir -p /etc/apt/preferences.d
cat > "$PARROT_PIN" <<EOF
Package: *
Pin: release a=${PARROT_SUITE}
Pin-Priority: 1
EOF

# === Menu tools ===
declare -A TOOLS=(
  [1]="parrot-tools"
  [2]="parrot-tools-web"
  [3]="parrot-tools-info"
  [4]="parrot-tools-pass"
  [5]="parrot-tools-vuln"
  [6]="parrot-tools-exploit"
  [7]="parrot-tools-wireless"
  [8]="parrot-tools-sniff"
  [9]="parrot-tools-forensics"
  [10]="parrot-tools-reverse"
  [11]="parrot-tools-crypto"
  [12]="parrot-tools-reporting"
  [13]="parrot-tools-anon"
  [14]="parrot-devel"
  [15]="parrot-tools-full"
)

apt update -y
echo "Pilih kategori Parrot tools:"
for i in "${!TOOLS[@]}"; do printf "%2d) %s\n" "$i" "${TOOLS[$i]}"; done
read -rp "Pilihan (pisahkan koma): " CHOICE

IFS=', ' read -r -a sel <<< "$CHOICE"
for c in "${sel[@]}"; do
  pkg="${TOOLS[$c]}"
  [[ -n "$pkg" ]] && apt install -y -t "$PARROT_SUITE" "$pkg"
done

echo "✅ Instalasi Parrot selesai."

