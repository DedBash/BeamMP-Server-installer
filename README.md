# unofficial-BeamMP-Server-installer

This is a third party script. I am not a developer of BeamMP and I am not on the BeamMP team. Otherwise, I just found it can be too hard for some to get beammp running properly.

Instructions:
 1. Please note that you need 'unzip', 'screen' and 'liblua5.3'. You can install it with this command as root: `apt install screen liblua5.3-dev unzip -y`
 2. Download the install script: `wget https://github.com/LiLZora-lut/unofficial-BeamMP-Server-installer/releases/download/v0.5_2106/install`
 3. Give the script rights to execute: `chmod +x install`
 4. Start the script: `./install`
 
 The server script works like this
  1. Start server: `./server start`
  2. Stop server: `./server stop`
  3. Restart server: `./server restart`
  6. Console of the server: `./server console`