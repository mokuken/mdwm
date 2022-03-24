
# MOKU'S DYNAMIC WINDOW MANAGER

![extra bar screenshot](bars.png)

## DWM PATCHES APPLIED

- **BORDER BAR**: Changeable size top border bar.
- **EXTRA BAR**: This patch will enable an extra status bar in dwm.
- **3 STATUS BAR**: 3 statuses, 1 in top right, 2 in left/right bottom
- **NO TITLE**: Doesn't show the title.
- **SWALLOW**: This patch adds "window swallowing" to dwm as known from Plan 9's windowing system rio.
- **VANITY GAPS**: gaps between windows and the screen edge in a flexible manner.

## DEPENDENCIES
ifconfig - Ifconfig is used to configure the kernel-resident network interfaces.
iwconfig - Iwconfig  is similar to ifconfig(8), but is dedicated to the wireless interfaces.
acpi - Shows information from the /proc filesystem, such as battery status or thermal information.
awk - gawk is a pattern scanning and processing language.
grep - Search for PATTERNS in each FILE.
cut - Print selected parts of lines from each FILE to standard output.
cat - Concatenate FILE(s) to standard output.
df - Show information about the file system on which each FILE resides, or all file systems by default.

## Installation

1. go in the main user directory, and type `git clone https://github.com/MokuKen/mdwm.git`. then press ENTER
2. go inside the folder of dwm `cd mdwm/dwm`
3. and install it `sudo make clean install` or `sudo make install`
4. go inside the folder of MDWM/script `cd mdwm/script`
5. Put the status script on your xinitrc `/home/username/mdwm/scripts/dwm-statusbar.sh &` 
6. restart dwm
7. Enjoy your new MDWM!!


## KEYBINDINGS

- EVERYTHING IS SET TO DEFAULT
- Open powermenu SHIFT + ALT + S
- Open DMENU CTRL + G
- Open a terminal SHIFT + ALT + ENTER
- Close a window SHIFT + ALT + C
- Quit DWM SHIFT + ALT + Q
- Change layout ALT + D or ALT + I


