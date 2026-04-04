#!/data/data/com.termux/files/usr/bin/bash

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Banner
banner() {
  clear
  echo -e "${MAGENTA}"
  echo "  ██████╗ ███████╗████████╗███████╗██╗  ██╗███████╗"
  echo "  ██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║ ██╔╝╚══███╔╝"
  echo "  ██████╔╝█████╗     ██║   █████╗  █████╔╝   ███╔╝ "
  echo "  ██╔══██╗██╔══╝     ██║   ██╔══╝  ██╔═██╗  ███╔╝  "
  echo "  ██║  ██║███████╗   ██║   ███████╗██║  ██╗███████╗"
  echo "  ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝"
  echo -e "${NC}"
  echo -e "  ${YELLOW}⚡ Professional VPN Control Center ⚡${NC}"
  echo -e "  ${CYAN}🔒 Powered by Cloudflare WARP 🔒${NC}"
  echo ""
}

# IP al
get_ip() {
  curl -s --max-time 5 https://api.ipify.org 2>/dev/null || echo "Bilinmiyor"
}

# Durum göster
show_status() {
  IP=$(get_ip)
  echo -e "  ${WHITE}🌐 Mevcut IP: ${CYAN}$IP${NC}"
  echo ""
}

# WARP uygulamasını aç
connect_vpn() {
  echo -e "${YELLOW}[*] WARP uygulaması açılıyor...${NC}"
  am start -n com.cloudflare.onedotonedotonedotone/.MainActivity 2>/dev/null
  sleep 1
  echo -e "${GREEN}[✓] WARP uygulaması açıldı!${NC}"
  echo -e "${CYAN}    Uygulamadan bağlandıktan sonra buraya dönün.${NC}"
  sleep 3
}

# IP Göster
show_ip() {
  clear
  banner
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${BOLD}           IP BİLGİLERİ${NC}"
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  ${YELLOW}[*] Bilgiler alınıyor...${NC}"
  IP=$(get_ip)
  INFO=$(curl -s --max-time 5 https://ipinfo.io/$IP 2>/dev/null)
  echo ""
  echo -e "  ${CYAN}IP Adresi  :${NC} $IP"
  echo -e "  ${CYAN}Ülke       :${NC} $(echo $INFO | grep -o '"country": "[^"]*"' | cut -d'"' -f4)"
  echo -e "  ${CYAN}Şehir      :${NC} $(echo $INFO | grep -o '"city": "[^"]*"' | cut -d'"' -f4)"
  echo -e "  ${CYAN}Bölge      :${NC} $(echo $INFO | grep -o '"region": "[^"]*"' | cut -d'"' -f4)"
  echo -e "  ${CYAN}Org        :${NC} $(echo $INFO | grep -o '"org": "[^"]*"' | cut -d'"' -f4)"
  echo ""
  echo -e "  ${YELLOW}Devam etmek için Enter'a bas...${NC}"
  read
}

# Hız testi
speed_test() {
  clear
  banner
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${BOLD}           HIZ TESTİ${NC}"
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  ${YELLOW}[*] Ping test ediliyor...${NC}"
  PING=$(ping -c 3 1.1.1.1 2>/dev/null | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
  echo -e "  ${CYAN}Ping (1.1.1.1): ${GREEN}${PING}ms${NC}"
  echo ""
  echo -e "  ${YELLOW}[*] İndirme hızı test ediliyor...${NC}"
  SPEED=$(curl -s --max-time 10 -w "%{speed_download}" -o /dev/null https://speed.cloudflare.com/__down?bytes=1000000 2>/dev/null)
  SPEED_MBPS=$(echo "$SPEED" | awk '{printf "%.2f", $1/131072}')
  echo -e "  ${CYAN}İndirme Hızı: ${GREEN}${SPEED_MBPS} Mbps${NC}"
  echo ""
  echo -e "  ${YELLOW}Devam etmek için Enter'a bas...${NC}"
  read
}

# WARP kurulum rehberi
warp_guide() {
  clear
  banner
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${BOLD}       WARP KURULUM REHBERİ${NC}"
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  ${YELLOW}1.${NC} Play Store'dan ${CYAN}'1.1.1.1'${NC} uygulamasını indir"
  echo -e "  ${YELLOW}2.${NC} Uygulamayı aç ve ${CYAN}'Bağlan'${NC} butonuna bas"
  echo -e "  ${YELLOW}3.${NC} VPN izni iste, ${CYAN}'İzin Ver'${NC} de"
  echo -e "  ${YELLOW}4.${NC} Bağlandıktan sonra bu menüye dön"
  echo ""
  echo -e "  ${GREEN}✓ Tamamen ücretsiz!${NC}"
  echo -e "  ${GREEN}✓ Root gerekmez!${NC}"
  echo -e "  ${GREEN}✓ Cloudflare sunucuları!${NC}"
  echo ""
  echo -e "  ${YELLOW}Devam etmek için Enter'a bas...${NC}"
  read
}

# Ana menü
main_menu() {
  while true; do
    clear
    banner
    show_status
    echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${MAGENTA}        🎮 ANA KONTROL MENÜSÜ${NC}"
    echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${GREEN}[1]${NC} 🔌 WARP Uygulamasını Aç"
    echo -e "  ${CYAN}[2]${NC} 🌐 IP Göster"
    echo -e "  ${WHITE}[3]${NC} ⚡ Hız Testi"
    echo -e "  ${YELLOW}[4]${NC} 📖 WARP Kurulum Rehberi"
    echo -e "  ${MAGENTA}[5]${NC} 🔄 IP Yenile"
    echo -e "  ${RED}[6]${NC} ❌ Çıkış"
    echo ""
    echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -ne "  ${YELLOW}👉 Seçiminiz: ${NC}"
    read -r choice

    case $choice in
      1) connect_vpn ;;
      2) show_ip ;;
      3) speed_test ;;
      4) warp_guide ;;
      5) clear; banner; show_status; sleep 2 ;;
      6) clear; echo -e "${MAGENTA}ReTeKZ VPN kapatıldı. Güle güle! 👋${NC}"; exit 0 ;;
      *) echo -e "${RED}Geçersiz seçim!${NC}"; sleep 1 ;;
    esac
  done
}

# Başlat
main_menu
