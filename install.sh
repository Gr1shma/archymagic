# Hello Bros Welcome
printf '\033c'
echo "Welcome to archy install bros"
pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true
lsblk
echo "Get ready to create partition"
echo "Enter the drive (like /dev/nvme0n1): "
read drive
cfdisk $drive
echo "Enter EFI partition (like /dev/nvme0n1p5): "
read efipartition
mkfs.vfat -F 32 $efipartition
mount --mkdir $efipartition /mnt/boot
echo "Enter the linux partition (like /dev/nvme0n1p6): "
read partition
mkfs.ext4 $partition
mount $partition /mnt
read -p "Did you also create swap partition? [y/n]" ansswap
if [[ $ansswap = y ]] ; then
  echo "Enter swap partition (like /dev/nvme0n1p7): "
  read swappartition
  mkswap $swappartition
  swapon $swappartition
fi
pacstrap /mnt base base-devel linux linux-firmware linux-headers vim nano intel-ucode networkmanager network-manager-applet wireless_tools bluez bluez-utils git
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/install2.sh
chmod +x /mnt/install2.sh
arch-chroot /mnt ./install2.sh
exit

#part2
printf '\033c'
ln -sf /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
passwd
echo "Enter Username: "
read username
useradd -m $username
passwd $username
usermod -aG wheel,storage,power,audio $username
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
pacman --noconfirm -S grub efibootmgr os-prober ntfs-3g
lsblk
echo "Enter EFI partition (like /dev/nvme0n1p5): "
read efipartition
read -p "Did you dual boot win and linux? [y/n]" answin
if [[ $answin = y ]] ; then
  lsblk
  echo "Enter windows boot partition (like /dev/nvme0n1p1): "
  read windowpartiton
  mkdir /mnt/windows/
  mount $windowpartiton /mnt/windows/
  echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
fi
mkdir /boot/efi
mount $efipartition /boot
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager bluetooth

pacman -S --noconfirm ntfs-3g zsh \
    hyprland waybar foot hyprpaper hyprlock \
    noto-fonts noto-fonts-emoji noto-fonts-cjk\
    ttf-jetbrains-mono ttf-font-awesome \
    sxiv mpv zathura zathura-pdf-mupdf ffmpeg imagemagick  \
    fzf man-db python-pywal swayidle \
    zip unzip unrar p7zip xdotool brightnessctl udisks2 \
    dosfstools git pipewire pipewire-pulse rsync dash \
    ripgrep libnotify dunst jq aria2 cowsay \
    dhcpcd network-manager-applet wireless_tools \
    wpa_supplicant pamixer \
    zsh-syntax-highlighting xdg-user-dirs libconfig \
    bluez bluez-utils blueman \ 

rm /bin/sh
ln -s dash /bin/sh
echo "Pre-Installation Finish Reboot now"
ai3_path=/home/$username/install3.sh
sed '1,/^#part3$/d' install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit

#part3
printf '\033c'
cd $HOME
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -fsri
cd $HOME

paru -S --noconfirm libxft-bgra-git yt-dlp-drop-in \
    neovim github-cli fzf tmux nodejs npm pnpm yarn \
    phinger-cursors qbittorrent firefox syncthing \
    nvidia nvidia-utils nvidia-settings auto-cpufreq \
    hyprshot btop go luarocks lua51 nsxiv btop pfetch \
    jq lazygit tree elixir zig \

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --quiet -y
cd $HOME
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/Gr1shma/hyprdots.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles
git clone --depth=1 https://github.com/Gr1shma/init.lua ~/.config/nvim

cd $HOME
mkdir dl dox music pix vid code projects personal
chsh -s $(which zsh)
rm ~/.zshrc ~/.zsh_history
ln -s ~/.config/zsh/zsh .zshrc
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dots config --local status.showUntrackedFiles no
exit
