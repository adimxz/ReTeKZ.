# ReTeKZ VPN 🔒

> Termux üzerinden root/sudo gerektirmeden çalışan WireGuard tabanlı VPN kurulum aracı.

![Platform](https://img.shields.io/badge/Platform-Termux-black?style=flat-square)
![Protocol](https://img.shields.io/badge/Protocol-WireGuard-blue?style=flat-square)
![Root](https://img.shields.io/badge/Root-Gerekmiyor-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

---

## Özellikler

- ⚡ Hızlı kurulum — tek komut
- 🔐 WireGuard protokolü
- 📱 Termux üzerinde çalışır
- 🚫 Root / sudo gerektirmez
- 📋 Otomatik anahtar üretimi
- 📷 QR kod desteği (WireGuard uygulaması için)
- 🎨 Renkli terminal arayüzü

---

## Kurulum

Termux'u aç ve şu komutu çalıştır:

```bash
pkg install git -y && git clone https://github.com/adimxz/ReTeKZ. && cd ReTeKZ && bash install.sh
```

---

## Kullanım

### Bağlan
```bash
wg-quick up ReTeKZ
```

### Bağlantıyı Kes
```bash
wg-quick down ReTeKZ
```

### Durum Kontrol
```bash
wg show
```

---

## Gereksinimler

- Android telefon
- [Termux](https://f-droid.org/packages/com.termux/) (F-Droid üzerinden indir)
- WireGuard destekli bir sunucu (VPS)

---

## Notlar

- Termux'u **F-Droid** üzerinden indirmeniz önerilir. Play Store sürümü güncel değil.
- Bağlanmak için bir WireGuard sunucusuna ihtiyacınız var.
- Config dosyası `~/.config/wireguard/ReTeKZ.conf` konumunda saklanır.

---

## Lisans

MIT License © ReTeKZ
