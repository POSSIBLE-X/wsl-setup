#!/bin/sh
USERNAME="possible"
echo $USERNAME
adduser --gecos "" --disabled-password $USERNAME
passwd -d $USERNAME
usermod -a -G sudo $USERNAME
echo "$USERNAME ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo

apt update
apt upgrade -y

echo "[user]" > /etc/wsl.conf
echo "default=$USERNAME" >> /etc/wsl.conf
echo "[boot]" >> /etc/wsl.conf
echo "systemd=true" >> /etc/wsl.conf

apt install -y openjdk-17-jdk openjdk-17-jre maven
apt install -y gnupg2 software-properties-common git git-lfs keychain

apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 

usermod -a -G docker $USERNAME

echo 'eval $(keychain --eval id_rsa)' >> /home/$USERNAME/.bashrc

echo 'RUNNING=`ps aux | grep dockerd | grep -v grep`' >> /home/$USERNAME/.bashrc
echo 'if [ -z "$RUNNING" ]; then' >> /home/$USERNAME/.bashrc
echo '    sudo dockerd > /dev/null 2>&1 &' >> /home/$USERNAME/.bashrc
echo '    disown' >> /home/$USERNAME/.bashrc
echo 'fi' >> /home/$USERNAME/.bashrc

cd /home/$USERNAME
mkdir workspace
export POSSIBLE_WORKSPACE=/home/$USERNAME/workspace

apt remove -y nodejs
apt remove -y npm
apt autoremove -y
NODE_MAJOR=20
apt-get install -y ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y

npm install -g @angular/cli@latest

sudo apt install -y python3-pip

apt install zsh -y
git clone https://github.com/ohmyzsh/ohmyzsh.git /home/$USERNAME/.oh-my-zsh
cp /home/$USERNAME/.oh-my-zsh/templates/zshrc.zsh-template /home/$USERNAME/.zshrc

chsh -s $(which zsh) $USERNAME
echo 'eval $(keychain --eval id_rsa)' >> /home/$USERNAME/.zshrc

echo 'RUNNING=`ps aux | grep dockerd | grep -v grep`' >> /home/$USERNAME/.zshrc
echo 'if [ -z "$RUNNING" ]; then' >> /home/$USERNAME/.zshrc
echo '    sudo dockerd > /dev/null 2>&1 &' >> /home/$USERNAME/.zshrc
echo '    disown' >> /home/$USERNAME/.zshrc
echo 'fi' >> /home/$USERNAME/.zshrc

chown -R $USERNAME:$USERNAME /home/$USERNAME


dockerd > /dev/null 2>&1 &
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
