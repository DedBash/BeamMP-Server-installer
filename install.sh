#Colors and other aguments
command='\033[1;32m'
version='\033[0;32m'
name='\033[0;35m'
default='\033[0m'
hide='\033[0;30m'
y='\033[0;36m'
n='\033[0;31m'
curver='0.8.8'
serverag1='$1'
serverag2='$0'
sign1='"'
rm README.md server
#headstart
echo -e "**************************************"
echo -e "* unofficial BeamMP Server installer *"
echo -e "*         By ${name}Kiznaiver System${default}        *"
echo -e "*            ${version}Version ${curver}${default}            *"
echo -e "**************************************"

#Test if all important programs are installed
echo -e "Check if all necessary programs are available"

### wget check ###
if dpkg-query -s wget 1>/dev/null 2>/dev/null; then
    echo -e "${y} wget is installed ${default}"
else
  echo -e "${n} wget is not installed ${default}"
  echo -e "You can download it with${command} sudo apt install wget -y${default}"
  ### screen check ### error ###
  if dpkg-query -s screen 1>/dev/null 2>/dev/null; then
      echo -e "${y} screen is installed ${default}"
  else
      echo -e "$n screen is not installed ${default}"
      echo -e "You can download it with sudo ${command}sudo apt install screen -y${default}"
  fi
  ### unzip check ### error ###
  if dpkg-query -s unzip 1>/dev/null 2>/dev/null; then
      echo -e "${y} unzip is installed ${default}"
  else
      echo -e "$n unzip is not installed ${default}"
      echo -e "You can download it with sudo ${command}sudo apt unzip wget -y${default}"
  fi
  ### liblua5.3-dev check ### error ###
  if dpkg-query -s liblua5.3-dev 1>/dev/null 2>/dev/null; then
    echo -e "${y} liblua5.3-dev is installed ${default}"
  else
    echo -e "$n liblua5.3-dev is not installed ${default}"
    echo -e "You can download it with sudo ${command}sudo apt install liblua5.3-dev -y${default}"
    exit
  fi
fi

### screen check ###
if dpkg-query -s screen 1>/dev/null 2>/dev/null; then
    echo -e "${y} screen is installed ${default}"
else
    echo -e "$n screen is not installed ${default}"
    echo -e "You can download it with sudo ${command}sudo apt install screen -y${default}"
    ### unzip check ### error ###
    if dpkg-query -s unzip 1>/dev/null 2>/dev/null; then
        echo -e "${y} unzip is installed ${default}"
    else
        echo -e "$n unzip is not installed ${default}"
        echo -e "You can download it with sudo ${command}sudo apt unzip wget -y${default}"
    fi
    ### liblua check ### error ###
    if dpkg-query -s liblua5.3-dev 1>/dev/null 2>/dev/null; then
      echo -e "${y} liblua5.3-dev is installed ${default}"
    else
      echo -e "$n liblua5.3-dev is not installed ${default}"
      echo -e "You can download it with sudo ${command}sudo apt install liblua5.3-dev -y${default}"
    fi
    exit
fi

### unzip check ###
if dpkg-query -s unzip 1>/dev/null 2>/dev/null; then
    echo -e "${y} unzip is installed ${default}"
else
    echo -e "$n unzip is not installed ${default}"
    echo -e "You can download it with sudo ${command}sudo apt unzip wget -y${default}"
    ### liblua check ### error ###
    if dpkg-query -s liblua5.3-dev 1>/dev/null 2>/dev/null; then
      echo -e "${y} liblua5.3-dev is installed ${default}"
    else
      echo -e "$n liblua5.3-dev is not installed ${default}"
      echo -e "You can download it with sudo ${command}sudo apt install liblua5.3-dev -y${default}"
    fi
    exit
fi

### liblua check ###
if dpkg-query -s liblua5.3-dev 1>/dev/null 2>/dev/null; then
  echo -e "${y} liblua5.3-dev is installed ${default}"
else
  echo -e "$n liblua5.3-dev is not installed ${default}"
  echo -e "You can download it with sudo ${command}sudo apt install liblua5.3-dev -y${default}"
  exit
fi

install_all(){
  read -p "What should the server folder be called? " fn
  if [ -d $fn ];
  then
    read -p "$fn already exists is to be driven forward [y/n] > " fne
    case $fne in
        [Yy]* ) cd $fn;;
        [Nn]* ) install_all; exit;;
    esac
  else
    mkdir $fn
    cd $fn
  fi
  echo Downloading:
  wget https://beammp.com/server/BeamMP_Server.zip -q --show-progress
  unzip BeamMP_Server.zip 1>/dev/null 2>/dev/null
  rm BeamMP-Server.exe
  rm BeamMP_Server.zip
  chmod +x BeamMP-Server-linux
  screen -AmdS install_temp ./BeamMP-Server-linux
  read -p "what should the server be called internally? > " sn1
  exec 3<> server
    echo "case $serverag1 in
    start)
        screen -AmdS $sn1 ./BeamMP-Server-linux
        sleep 0.5
        echo The $sn1 was started
    ;;
    stop)
        screen -r $sn1 -X quit
        sleep 0.5
        echo The $sn1 was stopped
    ;;
    restart)
        screen -r $sn1 -X quit
        sleep 0.5
        echo The $sn1 is restarted
        screen -AmdS $sn1 ./BeamMP-Server-linux
    ;;
    terminal)
	screen -r $sn1
    ;;
    help)
	echo ${sign1}These are all commands:
  ./server start
  ./server restart
  ./server stop
  ./server terminal${sign1}
    ;;
    *)
        echo Invalid usage: $serverag2 {start|stop|restart|terminal}
esac" >&3
  exec 3>&-
  chmod +x server
  echo ⠀
  echo -e "Before you start the server you have to edit the server. with ${command}nano /${fn}/ServerConfig.toml${default} so that you can enter your authkey."
  echo ⠀
  sleep 1
  echo ⠀
  echo -e "Then you can start the server with ${command}./${fn}/server start${default}."
  echo ⠀
  sleep 1
}
#Installs only the server script
install_script(){
  read -p "What should the server folder be called? " fn
  if [ -d $fn ];
  then
    cd $fn
  else
    read -p "$fn name is not an odner do you want to [c]reate it or [t]ry again" fne
    case $fne in
        [Tt]* ) install_script; exit;;
        [Cc]* ) mkdir $fn; cd $fn;;
    esac
  fi
  read -p "what should the server be called internally? > " sn2
  exec 3<> server
    echo "case $serverag1 in
    start)
        screen -AmdS $sn2 ./BeamMP-Server-linux
        sleep 0.5
        echo The $sn2 was started
    ;;
    stop)
        screen -r $sn2 -X quit
        sleep 0.5
        echo The $sn2 was stopped
    ;;
    restart)
        screen -r $sn2 -X quit
        sleep 0.5
        echo The $sn2 is restarted
        screen -AmdS $sn2 ./BeamMP-Server-linux
    ;;
    terminal)
  screen -r $sn2
    ;;
    help)
    echo ${sign1}These are all commands:
    ./server start
    ./server restart
    ./server stop
    ./server terminal${sign1}
    ;;
    *)
        echo Invalid usage: $serverag2 {start|stop|restart|terminal}
esac" >&3
  exec 3>&-
  sleep 1
  echo ⠀
  echo -e "Then you can start the server with ${command}./${fn}/server start${default}."
  echo ⠀
  sleep 1
}
#Installs only the BeamMP server
install_server(){
  read -p "What should the server folder be called? " fn
  if [ -d $fn ];
  then
    read -p "$fn Already exists is to be driven forward [y/n] > " fne
    case $fne in
        [Yy]* ) cd $fn;;
        [Nn]* ) install_server; exit;;
    esac
  else
    mkdir $fn
    cd $fn
  fi
  echo Downloding:
  wget https://beammp.com/server/BeamMP_Server.zip -q --show-progress
  unzip BeamMP_Server.zip 1>/dev/null 2>/dev/null
  rm BeamMP-Server.exe
  rm BeamMP_Server.zip
  chmod +x BeamMP-Server-linux
  screen -AmdS install_temp ./BeamMP-Server-linux
  sleep 1
  echo ⠀
  echo -e "Before you start the server you have to edit the ServerConfig.toml with ${command}nano /${fn}/ServerConfig.toml${default} so that you can enter your authkey."
  echo ⠀
  sleep 1
}
about(){
  echo -e "The script is from ${name}Kiznaiver System${default}"
  echo -e "I have nothing to do directly with the BeamMP team I just want to support it because I think the server install on the website is a little too complicated"
  echo -e "Links:
  My GitHub:       https://github.com/KIznaiver-system/unofficial-BeamMP-Server-installer
  BeamMP´s Github: https://github.com/BeamMP/BeamMP
  BeamMP:          https://beammp.com/"
  sleep 2
}
#Query what should be done
while true; do
    echo "What do you want to do
    1. Install only the BeamMP server
    2. Only the server management script
    3. Install both
    4. About this script"
    read -p "> " yn
    case $yn in
        [1]* ) install_server; exit;;
        [2]* ) install_script; exit;;
        [3]* ) install_all; exit;;
        [4]* ) about;;
        * ) echo "Please answer 1, 2, 3 or 4.";;
    esac
done
