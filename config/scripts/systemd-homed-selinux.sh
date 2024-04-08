#!/usr/bin/env bash

set -oue pipefail

rpm-ostree install policycoreutils-devel selinux-policy-devel setools-console
echo "Necessary packages installed."
git clone https://github.com/richiedaze/homed-selinux.git
echo "SELinux rules repo cloned."
cd homed-selinux
make -f /usr/share/selinux/devel/Makefile homed.pp
echo "SELinux rules built."
sudo semodule --install=homed.pp
echo "SELinux rules installed."
sudo restorecon -rv \
    /usr/lib/systemd/systemd-homed \
    /usr/lib/systemd/systemd-homework \
    /usr/lib/systemd/system/systemd-homed.service \
    /usr/lib/systemd/system/systemd-homed-activate.service \
    /var/lib/systemd/home
echo "SELinux rules applied."
sudo authselect enable-feature \
    with-systemd-homed
echo "Authselect support for systemd-homed enabled."
cd ..
rm -r homed-selinux
