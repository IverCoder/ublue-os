#!/usr/bin/env bash

set -oue pipefail

rpm-ostree install policycoreutils-devel selinux-policy-devel setools-console
sudo rpm-ostree apply-live
git clone https://github.com/richiedaze/homed-selinux.git
cd homed-selinux
make -f /usr/share/selinux/devel/Makefile homed.pp
sudo semodule --install=homed.pp
sudo restorecon -rv \
    /usr/lib/systemd/systemd-homed \
    /usr/lib/systemd/systemd-homework \
    /usr/lib/systemd/system/systemd-homed.service \
    /usr/lib/systemd/system/systemd-homed-activate.service \
    /var/lib/systemd/home
sudo authselect enable-feature \
    with-systemd-homed
cd ..
rm -r homed-selinux