#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\033[1;36m🔄 Kurulum başlatılıyor, lütfen bekleyin...\033[0m"

# 5 saniyelik geri sayım süreci
for i in 5 4 3 2 1; do
    echo -e "\033[1;33m⏳ Kurulumun tamamlanmasına $i saniye kaldı...\033[0m"
    sleep 1
done

echo -e "\033[1;36m📦 Sistem güncelleniyor (apt update & upgrade)...\033[0m"
apt update -y && apt upgrade -y --allow-downgrades 2>/dev/null

echo -e "\033[1;36m📦 Gerekli paketler kontrol ediliyor ve kuruluyor...\033[0m"
pkgs=("figlet" "mpv" "yt-dlp" "bc" "neofetch" "nano")
for pkg_name in "${pkgs[@]}"; do
    if ! command -v "$pkg_name" >/dev/null 2>&1; then
        echo -e "\033[1;33m➕ $pkg_name kuruluyor...\033[0m"
        pkg install "$pkg_name" -y
    fi
done

echo -e "\033[1;36m📥 Panel dosyası indiriliyor...\033[0m"
# GitHub'daki panel.sh dosyasının ham (raw) bağlantısı
if curl -fsSL -o ~/.panel.sh https://raw.githubusercontent.com/captainomercder-129/termux-style-older/main/panel.sh; then
    echo -e "\033[1;32m✅ [+] panel.sh başarıyla indirildi.\033[0m"
else
    echo -e "\033[1;31m❌ [-] panel.sh indirilemedi. İnternet bağlantınızı veya URL'yi kontrol edin.\033[0m"
    exit 1
fi

# Bashrc dosyası yoksa oluştur ve ayarları ekle
[ -f ~/.bashrc ] || touch ~/.bashrc
grep -q "source ~/.panel.sh" ~/.bashrc 2>/dev/null || echo "source ~/.panel.sh" >> ~/.bashrc
grep -q "^banner$" ~/.bashrc 2>/dev/null || echo "banner" >> ~/.bashrc

echo -e "\033[1;32m✅ Kurulum Başarıyla Tamamlandı!\033[0m"

# Paneli doğrudan başlat: mevcut süreci interaktif bir bash ile değiştiriyoruz.
# Böylece ~/.bashrc otomatik olarak panel.sh'i source eder, banner'ı gösterir
# ve alias'lar (1, 2, 3, srm, dvl...) kurulumun hemen ardından çalışır durumda olur.
exec bash
