@echo off
set wslname=possible
echo This script will create a WSL instance called %wslname%
mkdir D:\wsl\%wslname%
copy .\possible-wsl-setup.bat D:\wsl\%wslname%\
copy .\possible-wsl-setup.sh D:\wsl\%wslname%\
cd /D D:\wsl\%wslname%
echo "Downloading Ubuntu image"
powershell -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest https://cloud-images.ubuntu.com/wsl/noble/current/ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz -OutFile ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz"
echo "Creating Ubuntu WSL instance"
wsl.exe --import %wslname% D:\wsl\%wslname% .\ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz
echo "Copying Ubuntu WSL script to instance"
powershell -Command "Copy-Item -Path .\possible-wsl-setup.sh -Destination \\wsl.localhost\%wslname%\root\possible-wsl-setup.sh"
echo "Running Ubuntu WSL script on instance"
wsl.exe -d %wslname% bash -c "chmod +x /root/possible-wsl-setup.sh"
wsl.exe -d %wslname% -e /root/possible-wsl-setup.sh
wsl.exe --terminate %wslname%
echo "All done!"
pause
