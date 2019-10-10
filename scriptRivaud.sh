#!/bin/sh

# Recherche si  virtualbox et  vagrant sont bien installé et les installe le cas échéant

name=virtualbox
dpkg -s $name &> /dev/null  
if [ $? -ne 0 ]
then
    echo "not installed"  
    sudo apt-get update
    sudo apt-get install $name
else
    echo  -e "Super ! \e[31m Virtual box \e[0m est déjà intallé sur votre ordinateur ! "
fi

name=vagrant
dpkg -s $name &> /dev/null  
if [ $? -ne 0 ]
then
  echo "not installed"  
  sudo apt-get update
  sudo apt-get install $name
else
  echo  -e "Super ! \e[35m Vagrant\e[0m \e[0m est déjà intallé sur votre ordinateur ! "
fi


#vagrant update

read -p "Entrez le nom  que vous souhaitez donner au dossier de virtualisation  : " nameVirtualisation
mkdir $nameVirtualisation
cd $nameVirtualisation
ls
echo "Vagrant.configure("\"2"\") do |config|" > Vagrantfile

read -p "Voulez utiliser
1 - ubuntu/xenial64
2 - ubuntu/trusty64
3 - ubuntu/trusty32
 " Distribution
 # Choix des box avec un case
case $Distribution in
  1) 
  # "\" Permet au "" de d'échapper et d'écrire les quotes dans le Vagrantfile  
    echo "config.vm.box = "\"ubuntu/xenial64"\" " >> Vagrantfile
  ;;
  2) 
    echo "config.vm.box = "\"ubuntu/trusty64"\" " >> Vagrantfile
  ;;
  3) 
    echo "config.vm.box = "\"ubuntu/trusty32"\" " >> Vagrantfile
  ;;
  *) 
    echo "Etant indécit nous avons choisit pour vous la version ubuntu/xenial64 "
    echo "config.vm.box = "\"ubuntu/xenial64"\" " >> Vagrantfile
  ;;
esac

read -p "Voulez-vous modifier le nom du dossier local synchronisé ? 
1) Changer seulement le nom du dossier local synchronisé
2) Changer seulement le nom du dossier distant synchronisé
3) Changer le nom du dossier synchronisé local et distant 
4) Ne rien changer et utiliser les paramètres par défaut " choice
#Exectute les choix citer plus haut
case $choice in 
  1)
  echo "Vous avez bien choisi le choix 1 "
  read -p "Entrez le nom du dossier synchronisé : " nameFolder     
  echo "config.vm.synced_folder "\"./$nameFolder"\", "\"/var/www/html"\"" >> Vagrantfile
  mkdir $nameFolder
  ;;
  2)
  echo "Vous avez bien choisi le choix 2 "
  read -p "Entrez le nom du dossier synchronisé : "      
  echo "config.vm.synced_folder "\"./data"\", "\"/var/www/html"\"" >> Vagrantfile
  mkdir data 
  ;;
  3)
  echo "Vous avez bien choisi le choix 3"
  read -p "Entrez le nom du dossier synchronisé  local : " nameFolder  
  read -p "Entrez le nom du dossier synchronisé distant : " distantFolder
  echo "config.vm.synced_folder "\"./$nameFolder"\", "\"/var/www/$distantFolder"\"" >> Vagrantfile
  echo "Votre nom de  dossier synchronisé  local est : $nameFolder 
  Votre nom de  dossier synchronisé  distant est : $distantFolder "
  mkdir $nameFolder   
  ;;
  4)
  echo "Vous avez bien choisi le choix 4"
  echo "config.vm.synced_folder "\"./data"\", "\"/var/www/html"\"" >> Vagrantfile
  mkdir data
  ;;
  *) 
  echo -e "\e[1m \e[45m Ce n'est pas un choix valide  ! \e[0m"
  echo "Donc le choix par défaut 4 a été appliqué"
  echo "config.vm.synced_folder "\"./data"\", "\"/var/www/html"\"" >> Vagrantfile
  mkdir data
  ;;
esac

#Petit morceau de programme qui permet de changer l'adresse privé du réseau
read -p "Voulez-vous modifier l'adresse IP  actuel qui est 192.168.33.10 ? y/n " ipAdressChoice
if [[ $ipAdressChoice == "y" || $ipAdressChoice == "Y" ]]
then 
  read -p "Entrez les deux derniers chiffres de l'adresse IP que vous souhaitez modifier " numberIP
  echo "config.vm.network "\"private_network"\", ip: "\"192.168.33.$numberIP"\"" >> Vagrantfile
else
  echo " l'adresse IP choisi est celle par défaut 192.168.33.10 "
  echo "config.vm.network "\"private_network"\", ip: "\"192.168.33.10"\"" >> Vagrantfile
fi
#Ne pas oublier 
echo "end" >> Vagrantfile

vagrant status #montre les vagrants en cour d'utilisation 
#Propose à l'utilisateur d'éteindre des vagrants
 read -p "Voulez-vous interagir avec les vagrants ? y/n" choice
 if [ $choice == "y"]
 then
 read -p "voulez vous éteindre une machine y/n? " choice2
    if [ $choice2 == "y"]
    then
    read -p "Entre le nom de la machine que vous souhaitez éteindre " machine
    $machine halt
    fi
 fi

# Demande à l'utilisateur s'il veut démarrer le vagrant et le fait si oui
read -p "Voulez-vous démarrer votre vagrant ? y/n " begin
if [ $begin == "y" ]
then
  vagrant up
else
  echo -e " \e[5m \e[32mD'accord peut être une autre fois !\e[0m"
fi

#vagrant box update
