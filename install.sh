### BeamMP Server installer ###
## ##
linux=`awk -F= '/^NAME/{print $2}' /etc/os-release`;
release=`awk -F= '/^VERSION_ID/{print $2}' /etc/os-release`;
serverag1='$1'
serverag2='$0'
sign1='"'
yellow="\e[33m"
red="\e[31m"
green="\e[32m"
nocolor="\e[0m"
## MOTD ##
echo -e "${yellow}                                                                                
${yellow}                                #((((((((((%                                    
${yellow}                             ((          (                                      
${yellow}                          ((/            (                                      
${yellow}                       (((               (                                      
${yellow}     #(%*                                   /%#((((###%%&,,********,&%#((((%(   
${yellow}            ${nocolor}@@@@@@@                            @@@@   @@@.  @@@@@@              
${yellow}         #  ${nocolor}@@@@@%  #@@@@@  @@@@@  @@@@@@@@@@  @@@@  @@@@  @@@ %@@              
${yellow}        %  ${nocolor}/@@  @@ %@@@@@@ @@@@@@ #@% &@@ @@& *@@ @@@/&@@  @@,,${yellow}     #             
${yellow}       (   ${nocolor}@@@@@@   @@@@@  @@@@@  @@  @@  @@  @@  @@  @@   @@  ${yellow}     #@        .(  
${yellow}       (           (       #%##############%#%&                   (  %%%        
${yellow}        %#      &(                                     %#       #%              
${nocolor}                       BeamMP Server isntaller by Dedbash                        "
## Check root ##
if [ "$EUID" -ne 0 ]
  then echo -e "please start the program as root"
    echo -e "like sudo $0"
    echo "Good bye c:"
    exit 0
else 
    echo -e "You are root"
fi
## Check Version ##
if [[ $linux == *"Ubuntu"* ]] && [[ $release == *"20.04"* ]]
then    echo "The operating system Ubuntu 20.04 is supported"
        dllink="https://github.com/BeamMP/BeamMP-Server/releases/download/v3.1.1/BeamMP-Server-ubuntu-20.04"
elif [[ $linux == *"Ubuntu"* ]] && [[ $release == *"22.04"* ]]
then    echo "The operating system Ubuntu 22.04 is supported"
        dllink="https://github.com/BeamMP/BeamMP-Server/releases/download/v3.1.1/BeamMP-Server-ubuntu-22.04"
elif [[ $linux == *"Debian"* ]] && [[ $release == *"11"* ]]
then    echo "The operating system Debian 11 is supported"
        llink="https://github.com/BeamMP/BeamMP-Server/releases/download/v3.1.1/BeamMP-Server-debian-11"
else 
    echo "It currently only supports Ubuntu 20.04, 22.04 and Debian 11."
    echo "Good bye c:"
    exit 0
fi
## Update & upgrade system ##
echo -e "Update your System"
apt update -y && apt upgrade -y
## install reqs ##
if dpkg-query -s dialog 1>/dev/null 2>/dev/null;
    then echo -e "${green}dialog is installed${nocolor}"
    dialoginstall=""
else 
    echo -e "${red}dialog will be installed${nocolor}"
    dialoginstall="dialog"
fi
if dpkg-query -s wget 1>/dev/null 2>/dev/null;
    then echo -e "${green}wget is installed${nocolor}"
    wgetinstall=""
else 
    echo -e "${red}wget will be installed${nocolor}"
    wgetinstall="wget"
fi
if dpkg-query -s unzip 1>/dev/null 2>/dev/null;
    then echo -e "${green}unzip is installed${nocolor}"
    unzipinstall=""
else 
    echo -e "${red}unzip will be installed${nocolor}"
    unzipinstall="unzip"
fi
if dpkg-query -s screen 1>/dev/null 2>/dev/null;
    then echo -e "${green}screen is installed${nocolor}"
    screeninstall=""
else 
    echo -e "${red}screen will be installed${nocolor}"
    screeninstall="screen"
fi  
if dpkg-query -s liblua5.3-dev 1>/dev/null 2>/dev/null;
    then echo -e "${green}liblua5.3-dev is installed${nocolor}"
    liblua53devinstall=""
else 
    echo -e "${red}liblua5.3-dev will be installed${nocolor}"
    liblua53devinstall="liblua5.3-dev"
fi 
apt install -y $dialoginstall $wgetinstall $unzipinstall $screeninstall $liblua53devinstall
## Install BeamMP ##
install_beammp() {
    dialog  --backtitle "BeamMP server installer" \
            --title "BeamMP server creator" \
            --inputbox "Full folder Path !!no / at the end!!" 10 40 2> /tmp/beamfoldername
    clear
    foldername=`cat /tmp/beamfoldername`
    mkdir $foldername
    cd $foldername
    wget $dllink -O BeamMPServer
    chmod +x BeamMPServer
    cd ..
    rm -r /tmp/beamfoldername linux
    dialog  --backtitle "BeamMP server installer" \
            --title "BeamMP server creator" \
            --msgbox "The server was installed in the folder $foldername and can be executed there." 0 0
    clear
}
## Install BeamMP & script##
install_beammp_script() {
    dialog  --backtitle "BeamMP server installer" \
            --title "BeamMP server creator" \
            --inputbox "Full folder Path !!no / at the end!!" 10 40 2> /tmp/beamfoldername
    clear
    foldername=`cat /tmp/beamfoldername`
    mkdir $foldername
    cd $foldername
    wget $dllink -O BeamMPServer
    chmod +x BeamMPServer
    dialog  --backtitle "BeamMP server installer" \
            --title "BeamMP server creator" \
            --inputbox "Setup an Server Name" 10 40 2> /tmp/beamservername
    clear
    servername=`cat /tmp/beamservername`
    screen -AmdS temp ./BeamMPServer
    wait 1
    dialog  --backtitle "BeamMP server installer" \
            --title "BeamMP server creator INFO" \
            --colors --msgbox "In the next step you can edit the server config, edit only what you know and make sure to enter your authkey

\Z6AuthKey:\Z0
                You can create an AuthKey at: https://beammp.com/k/dashboard
                Texthelp: https://wiki.beammp.com/en/home/server-installation (2. Obtaining an Authentication Key)" 0 0

    dialog  --backtitle "BeamMP server installer" \
            --title "BeamMP Server Config" \
            --editbox ServerConfig.toml 40 80
    exec 3<> server
    echo "case $serverag1 in
    start)
        screen -AmdS $servername ./BeamMPServer
        sleep 0.5
        echo The $servername was started
    ;;
    stop)
        screen -r $servername -X quit
        sleep 0.5
        echo The $servername was stopped
    ;;
    restart)
        screen -r $servername -X quit
        sleep 0.5
        echo The $servername is restarted
        screen -AmdS $servername ./BeamMPServer
    ;;
    terminal)
	screen -r $servername
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
    cd ..
    rm -r /tmp/beamfoldername /tmp/beamservername server
    dialog  --backtitle "BeamMP server installer" \
            --title "BeamMP server creator" \
            --msgbox "The server was $servername installed in the folder $foldername.
            You can start the server with: cd $foldername && ./BeamMPServer" 0 0
    clear
}
## Info ##
info() {
    dialog  --backtitle "BeamMP server installer" \
            --title "BeamMP server creator INFO" \
            --colors --msgbox "\Z6What means:\Z0
            \Z7Install only BeamMP:\Z0 The option ensures that the BeamMP server executable is downloaded in an order and also gets rights
            \Z7Install BeamMP and Server script:\Z0 The option ensures that the BeamMP server executable is downloaded in an order and a script is created with which you can control the server.
            
            
\Z6The Script:\Z0
    ./server name start: Starts the server
    ./server name stop: Stops the server
    ./server name restart: Restarts the server
    ./server name terminal: Opens the terminal from the server 

    
\Z6AuthKey:\Z0
    You can create an AuthKey at: https://beammp.com/k/dashboard
    Texthelp: https://wiki.beammp.com/en/home/server-installation (2. Obtaining an Authentication Key)

    
\Z6Info:\Z0
    Script was written and mainteaned by DedBash
    Web: https://dedbash.xyz
    Github: https://github.com/DedBash
    Version 2.00.22.11
    

\Z6BeamMP:\Z0
    Server Version: v3.1.1
    Web: https://beammp.com/
    Github: https://github.com/BeamMP
    Discord: https://discord.gg/beammp" 0 0
}
## nogui ##
nogui() {
    mkdir OUTPUT
    cd OUTPUT
    wget $dllink -O BeamMPServer
    chmod +x BeamMPServer
    screen -AmdS temp ./BeamMPServer
}
## Start Dialog ##
startdialog(){
    dialog1=$(dialog    --backtitle "BeamMP server installer" \
                        --title "Select what you want to do" \
                        --menu "Choose an option with which you want to continue" 0 0 4 1 "Install only BeamMP" 2 "Install BeamMP and Server script" 3 "Info about" 4 "Exit"\
                        3>&1 1>&2 2>&3 3>&-)
    clear
    if [ $dialog1 = 1 ]
        then install_beammp
    elif [ $dialog1 = 2 ]
        then install_beammp_script
    elif [ $dialog1 = 3 ]
        then info
        startdialog
    elif [ $dialog1 = 4 ]
        then echo Good bye c:
    fi
}
case $1 in
    nogui) nogui
    ;;
    *) startdialog
esac
