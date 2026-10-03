#!/data/data/com.termux/files/usr/bin/bash
# termux-style-older — Saf Alias Tabanlı Terminal Paneli

OLDER_SRM_ACTIVE="true"
OLDER_DVLE_ACTIVE="false"
OLDER_STATE_FILE="$HOME/.older_hidden"
if [ -f "$OLDER_STATE_FILE" ] && [ "$(cat "$OLDER_STATE_FILE" 2>/dev/null)" = "true" ]; then
    OLDER_HIDDEN="true"
else
    OLDER_HIDDEN="false"
fi

center_text() {
    local text="$1"
    local width=$(tput cols 2>/dev/null || echo 50)
    local pad=$(( (width - ${#text}) / 2 ))
    [ "$pad" -lt 0 ] && pad=0
    printf "%*s%s\n" "$pad" "" "$text"
}

handle_sigint() {
    if [ "$OLDER_HIDDEN" = "true" ]; then
        clear
        echo -e "\033[0;32m~ \$\033[0m"
        return
    fi
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    local width=$(tput cols 2>/dev/null || echo 50)

    if command -v figlet >/dev/null 2>&1; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            local len=${#line}
            local pad=$(( (width - len) / 2 ))
            [ "$pad" -lt 0 ] && pad=0
            printf "%*s\033[1;32m%s\033[0m\n" "$pad" "" "$line"
        done < <(figlet "OLDER")
    else
        echo -e "\033[1;32m$(center_text "OLDER")\033[0m"
    fi

    echo -e "\033[1;36m$(center_text "termux-style-older")\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;33m⚠️ [*] İşlem kesildi, ana istemciye dönülüyor...\033[0m"
    sleep 1
    banner
}

trap 'handle_sigint' SIGINT

reset_termux() {
    guard_hidden || return
    clear
    echo -e "\033[1;31m🚨 [*] Yüklenen paketler ve tüm dosyalar siliniyor...\033[0m"
    pkg uninstall mpv figlet neofetch ani-cli bc yt-dlp python -y 2>/dev/null
    yes | pkg clean >/dev/null 2>&1
    yes | pkg autoremove >/dev/null 2>&1
    rm -rf "$HOME"/* "$HOME"/.[!.]* "$HOME"/..?* 2>/dev/null
    echo -e "\033[1;32m✅ [+] Termux tamamen sıfırlandı. Çıkış yapılıyor...\033[0m"
    exit
}

toggle_srm() {
    guard_hidden || return
    if [ "$OLDER_SRM_ACTIVE" = "true" ]; then
        OLDER_SRM_ACTIVE="false"
        echo -e "\033[1;31m❌ [-] Sürüm Bilgisi Kapatıldı\033[0m"
    else
        OLDER_SRM_ACTIVE="true"
        echo -e "\033[1;32m✨ [+] Sürüm Bilgisi Aktifleştirildi\033[0m"
    fi
    sleep 1
}

toggle_dvle() {
    guard_hidden || return
    if [ "$OLDER_DVLE_ACTIVE" = "true" ]; then
        OLDER_DVLE_ACTIVE="false"
        echo -e "\033[1;31m❌ [-] Geliştirme Sürümü Kapatıldı\033[0m"
    else
        OLDER_DVLE_ACTIVE="true"
        echo -e "\033[1;32m🛠️ [+] Geliştirme Sürümü Aktifleştirildi\033[0m"
    fi
    sleep 1
}

run_anicli() {
    guard_hidden || return
    clear
    if ! command -v ani-cli >/dev/null 2>&1; then
        echo -e "\033[1;36m🔄 ani-cli kuruluyor, lütfen bekleyin...\033[0m"
        pkg install ani-cli -y >/dev/null 2>&1 || pip install ani-cli >/dev/null 2>&1
    fi
    ani-cli
    printf "\n👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
}

run_figlet_menu() {
    guard_hidden || return
    clear
    printf "🎨 Figlet ile yazılacak metni girin: "
    read -r ftext
    if [ -n "$ftext" ]; then
        figlet "$ftext"
    fi
    printf "\n👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
}

show_mpv_info() {
    guard_hidden || return
    clear
    echo -e "\033[1;32mAni-cli İçin Mpv gerekir (play store)\033[0m"
}

print_controls() {
    echo -e "\033[0;35m--------------------------------------------------\033[0m"
    echo -e "\033[1;36m🎮 Kontroller:\033[0m"
    echo -e "\033[0;32m  [SPACE]      ⏸️ Duraklat / Devam Ettir\033[0m"
    echo -e "\033[0;32m  [<- / ->]    ⏩ 5sn Geri / İleri Sar\033[0m"
    echo -e "\033[0;32m  [9 / 0]      🔊 Sesi Azalt / Arttır\033[0m"
    echo -e "\033[0;32m  [m]          🔇 Sessize Al / Aç\033[0m"
    echo -e "\033[0;31m  [CTRL + C]   🛑 Durdur ve Menüye Dön\033[0m"
    echo -e "\033[0;35m--------------------------------------------------\033[0m"
}

bash_calc() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🧮 HESAP MAKİNESİ (Saf Bash)\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    printf "🔢 İşleminizi Girin (Örn: 5+5 veya 10*2): "
    read -r expr
    if [ -n "$expr" ]; then
        local result
        result=$(echo "scale=2; $expr" | bc 2>/dev/null || awk "BEGIN {print $expr}")
        echo -e "\033[1;32m✨ Sonuç: $result\033[0m"
    else
        echo -e "\033[0;31m⚠️ İşlem girilmedi.\033[0m"
    fi
    printf "\n👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
    banner
}

menu2() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m📦 YÜKLÜ PAKET LİSTESİ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    apt list --installed 2>/dev/null | cut -d/ -f1 | head -n 30
    echo -e "\033[0;35m==================================================\033[0m"
    printf "👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
    banner
}

menu3() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m💾 DİSK VE DEPOLAMA BİLGİSİ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    df -h "$HOME" | awk 'NR==2 {print " 📊 Toplam Alan : " $2 "\n 📁 Kullanılan  : " $3 "\n 📂 Boş Alan    : " $4 "\n 📈 Kullanım %  : " $5}'
    echo -e "\033[0;35m==================================================\033[0m"
    printf "👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
    banner
}

menu4() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🌐 AĞ VE IP TESTİ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    ifconfig 2>/dev/null | grep 'inet ' | awk '{print " 🌍 Yerel IP Adresiniz: " $2}'
    echo -e "\033[0;35m==================================================\033[0m"
    printf "👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
    banner
}

# 5. Seçenek: Bulunduğunuz klasördeki (proje dizini) notes.txt dosyasını açar
menu5() {
    guard_hidden || return
    local NOTES="./notes.txt"
    [ -f "$NOTES" ] || touch "$NOTES"
    if command -v nano >/dev/null 2>&1; then
        nano "$NOTES"
    else
        vi "$NOTES"
    fi
    banner
}

menu6() {
    guard_hidden || return
    clear
    local current_time=$(date +"%H:%M:%S")
    local current_date=$(date +"%d.%m.%Y")
    local current_day=$(date +"%A")
    local current_gmt=$(date +"%Z / GMT%z")

    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m⏰ SAAT, TARİH VE GMT BİLGİSİ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e " \033[1;33m⌚ Anlık Saat    :\033[0m $current_time"
    echo -e " \033[1;33m📅 Bugünün Tarihi :\033[0m $current_date ($current_day)"
    echo -e " \033[1;33m🌍 Zaman Dilimi   :\033[0m $current_gmt"
    echo -e "\033[0;35m==================================================\033[0m"
    printf "👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
    banner
}

menu7() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m💻 SİSTEM VE DONANIM BİLGİSİ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    if command -v neofetch >/dev/null 2>&1; then
        neofetch
    else
        echo -e " 🐧 İşletim Sistemi : $(uname -o)"
        echo -e " ⚙️ Çekirdek        : $(uname -r)"
        echo -e " 🏗️ Mimari          : $(uname -m)"
    fi

    echo -e "\033[0;35m==================================================\033[0m"
    printf "👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
    banner
}

play_audio() {
    guard_hidden || return
    clear
    if ! command -v mpv >/dev/null 2>&1 || ! command -v yt-dlp >/dev/null 2>&1; then
        echo -e "\033[1;31m❌ [-] mpv veya yt-dlp cihazda kurulu değil.\033[0m"
        printf "\n👉 Devam Etmek İçin Enter'a Basın..."
        read -r dummy
        banner
        return
    fi

    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🎵 MÜZİK ÇALAR MENÜSÜ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 🎧 MTB (Şarkı 1)\033[0m"
    echo -e "\033[0;33m [2] 🎶 Loli (Şarkı 2)\033[0m"
    echo -e "\033[0;36m [3] 🔗 Özel Link Gir\033[0m"
    echo -e "\033[0;35m [0] 🔙 Ana Menüye Dön\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    printf "👉 Seçiminiz [0-3]: "
    read -r m_secim

    case "$m_secim" in
        1)
            clear
            echo -e "\033[0;32m🚀 [+] MTB Şarkısı Başlatılıyor...\033[0m"
            print_controls
            mpv --no-video --quiet --volume=100 "ytdl://https://youtu.be/EUIMyjFB2TM?si=Ao0P3qB09ME6NsU-"
            printf "\n👉 Devam Etmek İçin Enter'a Basın..."
            read -r dummy
            ;;
        2)
            clear
            echo -e "\033[0;32m🚀 [+] Loli Şarkısı Başlatılıyor...\033[0m"
            print_controls
            mpv --no-video --quiet --volume=100 "ytdl://https://youtu.be/T8oeH99JDE4?si=C-xPydhYKnydwSvi"
            printf "\n👉 Devam Etmek İçin Enter'a Basın..."
            read -r dummy
            ;;
        3)
            clear
            printf "🔗 Çalınacak YouTube Linkini Girin: "
            read -r link
            if [ -n "$link" ]; then
                echo -e "\033[0;32m🚀 [+] Müzik başlatılıyor...\033[0m"
                print_controls
                mpv --no-video --quiet --volume=100 "ytdl://$link"
            fi
            printf "\n👉 Devam Etmek İçin Enter'a Basın..."
            read -r dummy
            ;;
    esac
    banner
}

OlderStyling() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    local width=$(tput cols 2>/dev/null || echo 50)

    if command -v figlet >/dev/null 2>&1; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            local len=${#line}
            local pad=$(( (width - len) / 2 ))
            [ "$pad" -lt 0 ] && pad=0
            printf "%*s\033[1;32m%s\033[0m\n" "$pad" "" "$line"
        done < <(figlet "OLDER")
    else
         echo -e "\033[1;32m$(center_text "OLDER")\033[0m"
    fi

    echo -e "\033[1;36m$(center_text "termux-style-older")\033[0m"

    if [ "$OLDER_SRM_ACTIVE" = "true" ]; then
        echo -e "\033[1;33m$(center_text "⭐ Older Paket V1")\033[0m"
    fi

    if [ "$OLDER_DVLE_ACTIVE" = "true" ]; then
        echo -e "\033[1;35m$(center_text "🛠️ Geliştirme Sürümü Aktif")\033[0m"
    fi

    echo -e "\033[0;35m==================================================\033[0m"
    printf "👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
    banner
}

Older_Banner() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m         ✨ OLDER - ÖZEL MENÜ ✨          \033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 🍿 Anime İzle (ani-cli)\033[0m"
    echo -e "\033[0;33m [2] 🎨 Figlet Çalıştır\033[0m"
    echo -e "\033[0;35m [3] 🔄 Sürüm Aç/Kapat\033[0m"
    echo -e "\033[0;36m [4] 🛠️ Geliştirme Sürümü Aç/Kapat\033[0m"
    echo -e "\033[0;36m [5] ℹ️ Ani-cli Mpv Bilgisi\033[0m"
    echo -e "\033[0;31m [6] 🏠 Ana Menüye Dön\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
}

developer_menu() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;33m        🛠️ GELİŞTİRİCİ SEÇENEKLERİ 🛠️         \033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;36m [1] 🔄 Sürüm Aç/Kapat (srm)\033[0m"
    echo -e "\033[0;36m [2] ⚡ Geliştirme Sürümü Aç/Kapat (dvle)\033[0m"
    echo -e "\033[0;36m [3] 🎵 Müzik Çalar\033[0m"
    echo -e "\033[0;36m [4] ✨ Older Styling\033[0m"
    echo -e "\033[0;34m [5] 📂 Depolama İzni Ver\033[0m"
    echo -e "\033[0;36m [6] 🔍 Çalışan Arka Plan Süreçleri\033[0m"
    echo -e "\033[1;36m [7] 🌟 Older-Banner Menüsü\033[0m"
    echo -e "\033[1;32m [8] 🏠 Ana Menüye Dön\033[0m"
    echo -e "\033[0;31m [9] 🚨 Termux'u Sıfırla\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
}

tkill_panel() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;31m⚠️ Panel kaldırılacak (sadece kendi dosyaları, başka hiçbir şeye dokunulmaz).\033[0m"
    echo -e "\033[1;33m👉 Onaylıyorsanız y yazın: \033[0m"
    read -r tkill_confirm
    if [ "$tkill_confirm" != "y" ]; then
        echo -e "\033[1;33m❌ İptal edildi.\033[0m"
        sleep 1
        banner
        return
    fi

    echo -e "\033[1;31m🗑️ [*] Panel kaldırılıyor (sadece kendi dosyaları)...\033[0m"
    rm -f "$HOME/.panel.sh" "$HOME/.older_hidden"
    if [ -f "$HOME/.bashrc" ]; then
        sed -i '/source ~\/\.panel\.sh/d; /^banner$/d' "$HOME/.bashrc" 2>/dev/null
    fi
    echo -e "\033[1;32m✅ [+] Panel kaldırıldı. Diğer dosyalarınıza dokunulmadı.\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🔁 Geri kurmak için:\033[0m"
    echo -e "\033[1;37m   cd ~ && cd termux-style-older\033[0m"
    echo -e "\033[1;37m   bash install.sh\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    sleep 1
    exit
}

guard_hidden() {
    [ "$OLDER_HIDDEN" = "true" ] && return 1
    return 0
}

hide_panel() {
    OLDER_HIDDEN="true"
    echo "true" > "$OLDER_STATE_FILE"
    clear
    echo -e "\033[0;32m~ \$\033[0m"
}

show_panel() {
    OLDER_HIDDEN="false"
    echo "false" > "$OLDER_STATE_FILE"
    banner
}

update_panel() {
    guard_hidden || return
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🔄 GÜNCELLEME KONTROL EDİLİYOR\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    local REPO_RAW="https://raw.githubusercontent.com/captainomercder-129/termux-style-older/main"
    local TMP_PANEL="$HOME/.panel.sh.new"
    local TMP_INSTALL="$HOME/.install.sh.new"
    local UPDATED="false"

    if curl -fsSL -o "$TMP_PANEL" "$REPO_RAW/panel.sh" 2>/dev/null; then
        if [ -f "$HOME/.panel.sh" ] && cmp -s "$TMP_PANEL" "$HOME/.panel.sh"; then
            echo -e "\033[1;33mℹ️ panel.sh zaten güncel.\033[0m"
        else
            cp "$TMP_PANEL" "$HOME/.panel.sh"
            echo -e "\033[1;32m✅ [+] panel.sh güncellendi.\033[0m"
            UPDATED="true"
        fi
    else
        echo -e "\033[1;31m❌ panel.sh kontrol edilemedi (internet?).\033[0m"
    fi

    local INSTALL_PATH=""
    if [ -f "./install.sh" ]; then
        INSTALL_PATH="./install.sh"
    elif [ -f "$HOME/termux-style-older/install.sh" ]; then
        INSTALL_PATH="$HOME/termux-style-older/install.sh"
    fi

    if curl -fsSL -o "$TMP_INSTALL" "$REPO_RAW/install.sh" 2>/dev/null; then
        if [ -n "$INSTALL_PATH" ]; then
            if cmp -s "$TMP_INSTALL" "$INSTALL_PATH"; then
                echo -e "\033[1;33mℹ️ install.sh zaten güncel.\033[0m"
            else
                cp "$TMP_INSTALL" "$INSTALL_PATH"
                echo -e "\033[1;32m✅ [+] install.sh güncellendi ($INSTALL_PATH).\033[0m"
                UPDATED="true"
            fi
        else
            echo -e "\033[1;33mℹ️ install.sh yerelde bulunamadı, kontrol atlandı.\033[0m"
        fi
    else
        echo -e "\033[1;31m❌ install.sh kontrol edilemedi (internet?).\033[0m"
    fi

    rm -f "$TMP_PANEL" "$TMP_INSTALL"
    echo -e "\033[0;35m==================================================\033[0m"

    if [ "$UPDATED" = "true" ]; then
        echo -e "\033[1;32m🔄 Panel yeniden yükleniyor...\033[0m"
        sleep 1
        source "$HOME/.panel.sh"
        banner
        return
    fi

    printf "\n👉 Devam Etmek İçin Enter'a Basın..."
    read -r dummy
    banner
}

banner() {
    if [ "$OLDER_HIDDEN" = "true" ]; then
        clear
        echo -e "\033[0;32m~ \$\033[0m"
        return
    fi
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;37m        🚀 HIZLI İŞLEM PANELİ 🚀          \033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 🧮 Hesap Makinesi (Saf Bash)\033[0m"
    echo -e "\033[0;33m [2] 📦 Yüklü Paket Listesi\033[0m"
    echo -e "\033[0;34m [3] 💾 Disk ve Storage\033[0m"
    echo -e "\033[0;36m [4] 🌐 Ağ ve IP Testi\033[0m"
    echo -e "\033[0;33m [5] 📝 Not Defteri\033[0m"
    echo -e "\033[0;36m [6] ⏰ Saat, Tarih ve GMT Bilgisi\033[0m"
    echo -e "\033[0;34m [7] 💻 Sistem ve Donanım Bilgisi\033[0m"
    echo -e "\033[0;33m [8] 🎵 Müzik Çalar\033[0m"
    echo -e "\033[0;32m [9] ✨ Older Styling\033[0m"
    echo -e "\033[0;31m [0] ❌ Çıkış\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
}

alias 1='bash_calc'
alias 2='menu2'
alias 3='menu3'
alias 4='menu4'
alias 5='menu5'
alias 6='menu6'
alias 7='menu7'
alias 8='play_audio'
alias 9='OlderStyling'
alias 0='exit'
alias old='reset_termux'
alias srm='toggle_srm'
alias dvl='developer_menu'
alias dvle='toggle_dvle'
alias ob='Older_Banner'
alias sto='termux-setup-storage'
alias psaux='ps aux'
alias ani='run_anicli'
alias fig='run_figlet_menu'
alias mpvinfo='show_mpv_info'
alias hide='hide_panel'
alias show='show_panel'
alias upd='update_panel'
alias tkill='tkill_panel'
