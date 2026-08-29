# 🖤 Monochrome Hyprland Dotfiles

A minimalist, clean, black-and-white Hyprland environment setup for Arch Linux (or any Wayland-based distribution).

![Hyprland Screenshot](https://raw.githubusercontent.com/lashchilin-andrii/b-w-hyprland-dotfiles/main/preview.png) <!-- Optional: Add a screenshot later -->

---

## 🛠️ Included Configurations

| Component | Directory / File | Description |
| :--- | :--- | :--- |
| **Compositor** | `hypr/` | Hyprland window manager rules, keybindings, and animations |
| **Bar** | `waybar/` | Status bar configured with monochrome styling |
| **Application Launcher** | `rofi/` | App launcher & power menu styled in black & white |
| **Terminal** | `kitty/` | Terminal emulator config with B&W color scheme |
| **Notifications** | `dunst/` | Lightweight notification daemon setup |
| **System Info** | `fastfetch/` | Minimal system information display |
| **Display Manager** | `sddm/` | Custom black & white SDDM login theme |
| **Theming (GTK)** | `gtk-3.0/`, `gtk-4.0/` | GTK application appearance rules |
| **Theming (Qt)** | `qt5ct/`, `qt6ct/` | Qt5 and Qt6 styling configs for consistency |
| **Screenshot Tool** | `swappy/` | Image editing and annotation tool config |
| **System Directories** | `user-dirs.dirs` | XDG user directory mappings |

---

## 🚀 Installation & Setup

### 1. Prerequisites
Ensure you have the core packages installed (Arch Linux example):

```bash
sudo pacman -S --needed hyprland waybar rofi-lbonn-wayland-git kitty dunst fastfetch qt5ct qt6ct swappy
