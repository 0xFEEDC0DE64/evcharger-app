FROM archlinux

RUN pacman -Syu --noconfirm sudo git jdk11-openjdk base-devel ninja \
 && rm -R /var/cache/pacman \
 && git clone https://github.com/KDAB/android_openssl /opt/android-sdk/android_openssl \
 && echo '%sudo	ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers \
 && useradd -m feedc0de \
 && groupadd sudo \
 && usermod -a -G sudo feedc0de \
 && sed -i 's/ debug / !debug /g' /etc/makepkg.conf

USER feedc0de

RUN cd \
 && git clone https://aur.archlinux.org/trizen.git \
 && cd trizen \
 && makepkg -si --noconfirm \
 && cd .. \
 && sudo rm -R trizen /var/cache/pacman

RUN trizen -S --noconfirm android-environment \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-sdk-build-tools \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-sdk \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-ndk \
 && sudo rm -R ~/.cache /var/cache/pacman

ENV ANDROID_NDK_ROOT=/opt/android-ndk

RUN trizen -S --noconfirm android-pkg-config \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-cmake \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-sdk-platform-tools \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-platform \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-aarch64-libjpeg-turbo \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-configure \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-aarch64-zlib \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-aarch64-libpng \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN gpg2 --recv-keys D894E2CE8B3D79F5 \
 && trizen -S --noconfirm android-aarch64-openssl \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-aarch64-qt6-base \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-aarch64-qt6-shadertools \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-aarch64-qt6-declarative \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-aarch64-qt6-websockets \
 && sudo rm -R ~/.cache /var/cache/pacman

RUN trizen -S --noconfirm android-aarch64-qt6-tools \
 && sudo rm -R ~/.cache /var/cache/pacman
