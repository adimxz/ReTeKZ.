#!/data/data/com.termux/files/usr/bin/bash

# ██████╗ ███████╗████████╗███████╗██╗  ██╗███████╗
# ██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║ ██╔╝╚══███╔╝
# ██████╔╝█████╗     ██║   █████╗  █████╔╝   ███╔╝ 
# ██╔══██╗██╔══╝     ██║   ██╔══╝  ██╔═██╗  ███╔╝  
# ██║  ██║███████╗   ██║   ███████╗██║  ██╗███████╗
# ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝
#
#         ReTeKZ VPN - Termux WireGuard Kurulum
#         github.com/KULLANICI_ADIN/ReTeKZ

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_banner() {
  echo -e "${CYAN}"
  echo "  ██████╗ ███████╗████████╗███████╗██╗  ██╗███████╗"
  echo "  ██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║ ██╔╝╚══███╔╝"
  echo "  ██████╔╝█████╗     ██║   █████╗  █████╔╝   ███╔╝ "
  echo "  ██╔══██╗██╔══╝     ██║   ██╔══╝  ██╔═██╗  ███╔╝  "
  echo "  ██║  ██║███████╗   ██║   ███████╗██║  ██╗███████╗"
  echo "  ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝"
  echo -e "${NC}"
  echo -e "${BOLD}         ReTeKZ VPN - Termux WireGuard Kurulum${NC}"
  echo -e "         ${YELLOW}github.com/KULLANICI_ADIN/ReTeKZ${NC}"
  echo ""
}

step() {
  echo -e "${GREEN}[*]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[!]${NC} $1"
}

error() {
  echo -e "${RED}[X]${NC} $1"
  exit 1
}

success() {
  echo -e "${GREEN}[✓]${NC} $1"
}

print_banner

# Paket güncelle
step "Termux paketleri güncelleniyor..."
pkg update -y && pkg upgrade -y || error "Paket güncellemesi başarısız!"
success "Paketler güncellendi."

# WireGuard kur
step "WireGuard kuruluyor..."
pkg install wireguard-tools -y || error "WireGuard kurulumu başarısız!"
success "WireGuard kuruldu."

# qrencode kur (QR kod için)
step "qrencode kuruluyor..."
pkg install qrencode -y 2>/dev/null
success "qrencode kuruldu."

# Config dizini oluştur
CONFIG_DIR="$HOME/.config/wireguard"
mkdir -p "$CONFIG_DIR"
step "Config dizini oluşturuldu: $CONFIG_DIR"

# Anahtar üret
step "ReTeKZ anahtarları üretiliyor..."
PRIVATE_KEY=$(wg genkey)
PUBLIC_KEY=$(echo "$PRIVATE_KEY" | wg pubkey)
success "Anahtarlar üretildi."

# Kullanıcıdan sunucu bilgilerini al
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD} Sunucu Bilgilerini Girin${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "$(echo -e ${YELLOW}"Sunucu IP adresi: "${NC})" SERVER_IP
read -p "$(echo -e ${YELLOW}"Sunucu Public Key: "${NC})" SERVER_PUBKEY
read -p "$(echo -e ${YELLOW}"Port (varsayılan 51820): "${NC})" SERVER_PORT
SERVER_PORT=${SERVER_PORT:-51820}
read -p "$(echo -e ${YELLOW}"VPN IP (varsayılan 10.0.0.2/24): "${NC})" VPN_IP
VPN_IP=${VPN_IP:-10.0.0.2/24}
read -p "$(echo -e ${YELLOW}"DNS (varsayılan 1.1.1.1): "${NC})" DNS_IP
DNS_IP=${DNS_IP:-1.1.1.1}

echo ""

# Config dosyası oluştur
CONFIG_FILE="$CONFIG_DIR/ReTeKZ.conf"

cat > "$CONFIG_FILE" <<EOF
# ReTeKZ VPN Konfigürasyonu
# Oluşturulma: $(date)

[Interface]
PrivateKey = $PRIVATE_KEY
Address = $VPN_IP
DNS = $DNS_IP

[Peer]
PublicKey = $SERVER_PUBKEY
Endpoint = $SERVER_IP:$SERVER_PORT
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF

success "Config dosyası oluşturuldu: $CONFIG_FILE"

# Public key'i göster
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD} ReTeKZ Kurulum Tamamlandı! 🎉${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}Senin Public Key'in (sunucuya ekle):${NC}"
echo -e "${GREEN}$PUBLIC_KEY${NC}"
echo ""
echo -e "${BOLD}Bağlanmak için:${NC}"
echo -e "  ${CYAN}wg-quick up ReTeKZ${NC}"
echo ""
echo -e "${BOLD}Bağlantıyı kesmek için:${NC}"
echo -e "  ${CYAN}wg-quick down ReTeKZ${NC}"
echo ""
echo -e "${BOLD}Durum kontrol:${NC}"
echo -e "  ${CYAN}wg show${NC}"
echo ""

# QR kod göster
if command -v qrencode &> /dev/null; then
  echo -e "${BOLD}QR Kod (WireGuard uygulaması için):${NC}"
  qrencode -t ansiutf8 < "$CONFIG_FILE"
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${YELLOW}ReTeKZ VPN by github.com/KULLANICI_ADIN${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
