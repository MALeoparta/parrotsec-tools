#### PARROTSEC TOOLS :

'''
curl -fsSL https://deb.parrot.sh/parrot/mirrors/parrot.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/parrot-archive-keyring.gpg

sudo apt install -y parrot-archive-keyring || curl -fsSL https://deb.parrot.sh/parrot/mirrors/parrot.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/parrot-archive-keyring.gpg

echo "deb-src https://deb.parrot.sh/parrot lory main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/parrot.list && sudo apt update
'''
