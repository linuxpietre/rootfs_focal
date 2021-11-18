#! /bin/sh
sudo apt install debootstrap -y
mkdir /focal
debootstrap --foreign focal /focal
sudo mount -o bind /dev /focal/dev && sudo mount -o bind /dev/pts /focal/dev/pts && sudo mount -t sysfs sys /focal/sys && sudo mount -t proc proc /focal/proc
#script de creación de archivo de instalación
> /home/config.sh
cat <<+>> /home/config.sh
#!/bin/sh
echo " Configurando debootstrap segunda fase"
sleep 3
/debootstrap/debootstrap --second-stage
export LANG=C
echo "deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
apt-get update
echo "Reconfigurando parametros locales"
locale-gen es_ES.UTF-8
export LC_ALL="es_ES.UTF-8"
update-locale LC_ALL=es_ES.UTF-8 LANG=es_ES.UTF-8 LC_MESSAGES=POSIX
dpkg-reconfigure locales
dpkg-reconfigure -f noninteractive tzdata
apt-get upgrade -y 
hostnamectl set-hostname focal
sudo apt-get install htop -y
apt-get -f install
apt-get clean
adduser focal
addgroup focal sudo
addgroup focal adm
addgroup focal users
+
chmod +x  /home/config.sh
sudo cp  /home/config.sh /focal/home
chroot /focal /bin/sh -i ./home/config.sh
