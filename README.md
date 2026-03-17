# Maturation
My personal ricing of [MangoWC](https://mangowc.vercel.app) using ARU and CachyOS optimization.
This project aims to bring optimization, integration, candy-eye to your desktop.
This project is in passive development.
Thanks to [ventureo](https://codeberg.org/ventureo) for mainteining the [ARU](https://ventureo.codeberg.page) and [CachyOS](https://cachyos.org/), especially the [wiki](https://wiki.cachyos.org/)

## Applications
| Application Type         | Application Realization     |
| ------------------------ | --------------------------- |
| Compositor               | mangowc                     |
| Browser                  | firefox                     |
| App Launcher             | fuzzel                      |
| Terminal                 | foot                        |
| Shell                    | zsh                         |
| File Manager             | yazi                        |
| Text Editor              | neovim(astronvim)           |
| Resource Monitor         | btop++                      |
| Video/Audio Playback     | mpv                         |
| Screenshot Tools         | flameshot                   |
| Office Suite             | libre office                |
| Video Editing            | losslesscut                 |
| Graphics Editor          | gimp                        |
| Messengers               | vesktop, telegram           |
| Email Client             | ThunderBird                 |
| Games                    | steam/wine/wine-based forks |
| Network                  | networkmanager              |
| Bar                      | waybar                      |
| Password Manager         | Bitwarden                   |
| Clipboard Manager        | copyq                       |
| Bluetooth                | blueman                     |
| Torrent Client           | qbittorrent                 |
| XDG                      | xdg-desktop-portal-wlr/termfilechooser-hunkyburrito |
| Polkit GUI               | soteria                     |
| Screen Locker            | swaylock                    |
| Wallpaper                | awww                        |
| Color Picker             |                             |
| Idle daemon              |                             |
| Color Temperature Filter |                             |
| System Info              |                             |
| Keyboard Remapper        | keyd                        |
| Notification Manager     | swaync                      |
| Mixer                    | pavucontrol                 |
| zram                     | zram-generator              |
| Cleaner                  | Bleachbit                   |

TODO List:
Scripts:
- [ ] arch.sh
	- [ ] Btrfs
	- [ ] SystemD
	- [ ] Limine
	- [x] Copy repository to installed system
- [ ] install.sh
	- [ ] config.sh
		- [x] Root Directory
		- [x] Language
		- [x] CPU
		- [x] GPU
		- [x] Disk
	 - [ ] base.sh
		- [x] update keyrings
		- [x] add extra repositories
		- [x]  mirrors update with reflector
		- [x] packet manager settings(parallel download and timeouts)
		- [x] install basic packages (microcode, git, base-devel, other firmware modules) 
		- [x] Install and set GPU drivers (Nvidia, AMD, Intel)
	- [ ] hyprland.sh
		- [ ] Wayland and other dependies 
		- [x] Hyprland Ecosystem
		- [ ] Hyprland config based on hardware
		- [ ] Theme
		- [ ] Icons
		- [ ] Cursor
	- [ ] apps.sh
		- [x] install required packages
		- [ ] safe current config
		- [ ] copy config files
	- [ ] apps-extra.sh 
		- [ ] Davinci Resolve
		- [ ] Xray
	- [ ] wine.sh
		- [ ] Proton GE
	- [ ] optimization.sh
		- [x] decrease booting time (initramfs)
		- [x] zram-generator
		- [x] earlyoom
		- [x] ananicy cpp
		- [x] irqbalance
		- [ ] compilation flags
		- [ ] tmpfs
		- [ ] ccache
		- [ ] clang
		- [ ] pipewire
		- [ ] disc prevention
		- [ ] monitor overclock
		- [ ] kernel settings
- [ ] uninstall.sh

- [ ] Configure every app
- [ ] Configure themes and icons
- [ ] Custom bind and binds wiki
- [ ] Building with yay and git clone+makepkg wrapped in script

 [screensharing](https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580)
 https://astronvim.com/
 https://github.com/LazyVim/LazyVim
 https://www.lunarvim.org/
 https://nvchad.com/

 GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb SDL_VIDEODRIVER=x11 %command% for albion

