# gnome keyring

`pacman -S gnome-keyring libsecret`

`seahorse` for GUI management

https://wiki.archlinux.org/title/GNOME/Keyring#Automatically_change_keyring_password_with_user_password

```
# /etc/pam.d/login

# ...
auth       optional     pam_gnome_keyring.so
# ...
session    optional     pam_gnome_keyring.so auto_start
# ...
```

```
# /etc/pam.d/passwd

# ...
password    optional    pam_gnome_keyring.so
```
