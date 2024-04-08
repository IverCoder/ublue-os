# Set up device after installation
personal-setup:
    ujust enroll-secure-boot-key
    ujust configure-nvidia kargs
    ujust fix-grub
    ujust arduino-sandbox
    ujust bottles-runtimes
    ujust bypass-prism-launcher-drm
    ujust firefox-gnome-theme
    echo Also run `ujust configure-nvidia-optimus power-management` and optionally `ujust configure-nvidia-optimus igpu-workaround` after restarting, when the NVIDIA driver gets activated.

# Fix GRUB entries
fix-grub:
    pkexec touch /boot/grub2/.grub2-blscfg-supported
    pkexec grub2-mkconfig -o /etc/grub2-efi.cfg

# Properly sandbox Arduino IDE v2
arduino-sandbox:
    flatpak override --user --filesystem=xdg-documents/Arduino --nofilesystem=home --persist=.arduino15 --persist=.arduinoIDE --persist=Arduino cc.arduino.IDE2
    ln -s ~/.var/app/cc.arduino.IDE2/Arduino ~/Documents/Arduino

# Install additional runtimes for Bottles
bottles-runtimes:
    flatpak install --user flathub org.freedesktop.Platform.VulkanLayer.gamescope//23.08
    flatpak install --user flathub org.freedesktop.Platform.VulkanLayer.MangoHud//23.08
    flatpak install --user flathub org.freedesktop.Platform.VulkanLayer.vkBasalt//23.08
    flatpak install --user flathub org.freedesktop.Platform.VulkanLayer.OBSVkCapture//23.08

# Bypass Prism Launcher's DRM
bypass-prism-launcher-drm:
    touch ~/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher/accounts.json
    echo '{"accounts": [{"entitlement": {"canPlayMinecraft": true,"ownsMinecraft": true},"type": "Offline"}],"formatVersion": 3}' > ~/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher/accounts.json

# Install the Firefox GNOME theme
firefox-gnome-theme:
    flatpak run org.mozilla.firefox
    sleep 5
    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash

# Make a new home-encrypted user
new-homed-user:
    sudo homectl create $1 \
        --password-change-now=true \
        --storage=luks --fs-type=btrfs \
        --luks-extra-mount-options=defcontext=system_u:object_r:user_home_dir_t:s0

# Share audio
share-audio:
    as-cmd -b 192.168.0.109
