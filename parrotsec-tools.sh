#!/usr/bin/env bash
# Interactive installer for Parrot Security "parrot-tools-*" metapackages
# WARNING: run on Debian/Ubuntu-based systems only with care (use VM if ragu)

set -euo pipefail

PARROT_SUITE="lory"
APT_TARGET="-t ${PARROT_SUITE}"
NO_RECOMMENDS="--no-install-recommends"

# --- Common Parrot metapackages (update if names differ on your version) ---
# Examples: parrot-tools-infogathering, parrot-tools-forensics, parrot-tools-web, parrot-tools-full, etc.
declare -A CATS
CATS=(
  [1]="parrot-tools-infogathering"
  [2]="parrot-tools-forensics"
  [3]="parrot-tools-web"
  [4]="parrot-tools-reversing"
  [5]="parrot-tools-exploitation"
  [6]="parrot-tools-passwords"
  [7]="parrot-tools-wireless"
  [8]="parrot-tools-crypto"
  [9]="parrot-tools-cloud"
  [10]="parrot-tools-automotive"
  [11]="parrot-tools-sdr"
  [12]="parrot-tools-reporting"
  [13]="parrot-tools-full"     # installs full parrot toolset (very large)
  [14]="parrot-pico"          # minimal
  [15]="parrot-mini"          # smaller
  [0]="exit"
)

show_menu() {
  cat <<EOF
Pilih angka kategori Parrot untuk diinstall (pisahkan koma untuk banyak pilihan)
Contoh: 1,3,5
-------------------------------------------------
 1)  parrot-tools-infogathering
 2)  parrot-tools-forensics
 3)  parrot-tools-web
 4)  parrot-tools-reversing
 5)  parrot-tools-exploitation
 6)  parrot-tools-passwords
 7)  parrot-tools-wireless
 8)  parrot-tools-crypto
 9)  parrot-tools-cloud
10)  parrot-tools-automotive
11)  parrot-tools-sdr
12)  parrot-tools-reporting
13)  parrot-tools-full (full toolset; very large)
14)  parrot-pico (minimal)
15)  parrot-mini (small set)
 0)  Exit
-------------------------------------------------
EOF
}

main() {
  show_menu
  read -rp $'Pilihan> ' CHOICE
  [[ -z "$CHOICE" ]] && { echo "Tidak ada pilihan. Keluar."; exit 0; }

  IFS=', ' read -r -a SEL <<< "$CHOICE"

  INSTALL_LIST=()
  for s in "${SEL[@]}"; do
    s=$(echo "$s" | tr -d '[:space:]')
    if [[ "$s" == "0" ]]; then
      echo "Keluar."
      exit 0
    fi
    if [[ -n "${CATS[$s]:-}" ]]; then
      INSTALL_LIST+=("${CATS[$s]}")
    else
      echo "Pilihan tidak valid: $s"
    fi
  done

  if [[ ${#INSTALL_LIST[@]} -eq 0 ]]; then
    echo "Tidak ada paket terpilih. Keluar."
    exit 0
  fi

  echo "Paket yang akan diinstall dari ${PARROT_SUITE}:"
  for p in "${INSTALL_LIST[@]}"; do echo " - $p"; done

  read -rp $'Lanjutkan instalasi? (y/N): ' CONF
  if [[ "$CONF" != "y" && "$CONF" != "Y" ]]; then
    echo "Dibatalkan."
    exit 0
  fi

  sudo apt update -y

  for pkg in "${INSTALL_LIST[@]}"; do
    echo "Installing ${pkg} ..."
    sudo apt install -y ${APT_TARGET} ${NO_RECOMMENDS} "${pkg}" || {
      echo "Gagal menginstall ${pkg}. Lanjut ke paket berikutnya."
    }
  done

  echo "Selesai. Periksa paket yang terpasang dan dependency conflicts jika ada."
}

main "$@"
