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

# WARP kurulu mu kontrol et
check_warp() {
  if ! command -v warp-cli &> /dev/null; then
    echo -e "${YELLOW}[!] WARP kurulu değil, kuruluyor...${NC}"
    pkg install cloudflare-warp -y 2>/dev/null
    if ! command -v warp-cli &> /dev/null; then
      echo -e "${RED}[X] WARP kurulamadı. Manuel kurulum gerekiyor.${NC}"
      echo -e "${CYAN}    pkg install cloudflare-warp${NC}"
      sleep 2
    fi
  fi
}

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

# Durum göster
show_status() {
  IP=$(curl -s --max-time 3 https://api.ipify.org 2>/dev/null || echo "Bilinmiyor")
  
  if warp-cli status 2>/dev/null | grep -q "Connected"; then
    VPN_STATUS="${GREEN}🟢 AÇIK${NC}"
  else
    VPN_STATUS="${RED}🔴 KAPALI${NC}"
  fi
  
  echo -e "  ${WHITE}🌐 Mevcut IP: ${CYAN}$IP${NC}"
  echo -e "  ${WHITE}🔒 VPN: $(echo -e $VPN_STATUS)"
  echo ""
}

# Bağlan
connect_vpn() {
  echo -e "${YELLOW}[*] VPN'e bağlanılıyor...${NC}"
  warp-cli register 2>/dev/null
  warp-cli connect 2>/dev/null
  sleep 2
  if warp-cli status 2>/dev/null | grep -q "Connected"; then
    echo -e "${GREEN}[✓] VPN bağlantısı kuruldu!${NC}"
  else
    echo -e "${RED}[X] Bağlantı kurulamadı!${NC}"
  fi
  sleep 2
}

# Bağlantıyı kes
disconnect_vpn() {
  echo -e "${YELLOW}[*] VPN bağlantısı kesiliyor...${NC}"
  warp-cli disconnect 2>/dev/null
  sleep 2
  echo -e "${GREEN}[✓] VPN bağlantısı kesildi!${NC}"
  sleep 2
}

# Durum kontrol
status_check() {
  clear
  banner
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${BOLD}       DETAYLI DURUM RAPORU${NC}"
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  show_status
  echo -e "  ${WHITE}WARP Durumu:${NC}"
  warp-cli status 2>/dev/null || echo -e "  ${RED}WARP çalışmıyor${NC}"
  echo ""
  echo -e "  ${YELLOW}Devam etmek için Enter'a bas...${NC}"
  read
}

# IP göster
show_ip() {
  clear
  banner
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${BOLD}           IP BİLGİLERİ${NC}"
  echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  IP=$(curl -s https://api.ipify.org 2>/dev/null)
  INFO=$(curl -s https://ipinfo.io/$IP 2>/dev/null)
  echo -e "  ${CYAN}IP Adresi  :${NC} $IP"
  echo -e "  ${CYAN}Ülke       :${NC} $(echo $INFO | grep -o '"country": "[^"]*"' | cut -d'"' -f4)"
  echo -e "  ${CYAN}Şehir      :${NC} $(echo $INFO | grep -o '"city": "[^"]*"' | cut -d'"' -f4)"
  echo -e "  ${CYAN}Org        :${NC} $(echo $INFO | grep -o '"org": "[^"]*"' | cut -d'"' -f4)"
  echo ""
  echo -e "  ${YELLOW}Devam etmek için Enter'a bas...${NC}"
  read
}

# Hız testi
speed_test() {
  clear
  banner
  echo -e "  ${YELLOW}[*] Bağlantı test ediliyor...${NC}"
  echo ""
  PING=$(ping -c 3 1.1.1.1 2>/dev/null | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
  echo -e "  ${CYAN}Ping (1.1.1.1): ${GREEN}${PING}ms${NC}"
  echo ""
  echo -e "  ${YELLOW}Devam etmek için Enter'a bas...${NC}"
  read
}

# Kurulum
install_warp() {
  clear
  banner
  echo -e "  ${YELLOW}[*] Cloudflare WARP kuruluyor...${NC}"
  pkg update -y
  pkg install cloudflare-warp -y
  if command -v warp-cli &> /dev/null; then
    echo -e "  ${GREEN}[✓] WARP başarıyla kuruldu!${NC}"
    warp-cli register
  else
    echo -e "  ${RED}[X] Kurulum başarısız!${NC}"
  fi
  sleep 2
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
    echo -e "  ${GREEN}[1]${NC} 🔌 VPN'e Bağlan"
    echo -e "  ${RED}[2]${NC} 🔴 VPN'den Çık"
    echo -e "  ${CYAN}[3]${NC} 📊 Durum Kontrol"
    echo -e "  ${YELLOW}[4]${NC} 🌐 IP Göster"
    echo -e "  ${WHITE}[5]${NC} ⚡ Hız Testi"
    echo -e "  ${MAGENTA}[6]${NC} 🔧 WARP Kur/Yenile"
    echo -e "  ${RED}[7]${NC} ❌ Çıkış"
    echo ""
    echo -e "  ${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -ne "  ${YELLOW}👉 Seçiminiz: ${NC}"
    read -r choice

    case $choice in
      1) connect_vpn ;;
      2) disconnect_vpn ;;
      3) status_check ;;
      4) show_ip ;;
      5) speed_test ;;
      6) install_warp ;;
      7) clear; echo -e "${MAGENTA}ReTeKZ VPN kapatıldı. Güle güle! 👋${NC}"; exit 0 ;;
      *) echo -e "${RED}Geçersiz seçim!${NC}"; sleep 1 ;;
    esac
  done
}

# Başlat
check_warp
main_menu
