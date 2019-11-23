#!/bin/bash
clear

server-install () {

valid_domain=0

printf "\nInstall directory "[$(pwd)"/ripple"]": "
read MasterDir
MasterDir=${MasterDir:=$(pwd)"/ripple"}

printf "\n\n..:: NGINX CONFIGS ::.."
while [ $valid_domain -eq 0 ]
do
printf "\nMain domain name: "
read domain

	printf "\n\nFrontend: $domain"
	printf "\nBancho: c.$domain"
	printf "\nAvatar: a.$domain"
	printf "\nBackend: old.$domain"
	printf "\n\nIs this configuration correct? [y/n]: "
	read q
	if [ "$q" = "y" ]; then
		valid_domain=1
	fi
fi
done

printf "\n\n..:: BANCHO SERVER ::.."
printf "\ncikey [changeme]: "
read peppy_cikey
peppy_cikey=${peppy_cikey:=changeme}

printf "\n\n..:: LETS SERVER::.."
printf "\nosuapi-apikey [YOUR_OSU_API_KEY_HERE]: "
read lets_osuapikey
lets_osuapikey=${lets_osuapikey:=YOUR_OSU_API_KEY_HERE}
printf "\nPP Cap [700]: "
read pp_cap
pp_cap=${pp_cap:=700}

printf "\n\n..:: FRONTEND ::.."
printf "\nPort [6969]: "
read hanayo_port
hanayo_port=${hanayo_port:=6969}
printf "\nAPI Secret [Potato]: "
read hanayo_apisecret
hanayo_apisecret=${hanayo_apisecret:=Potato}

printf "\n\n..:: DATABASE ::.."
printf "\nUsername [root]: "
read mysql_usr
mysql_usr=${mysql_usr:=root}
printf "\nPassword [meme]: "
read mysql_psw
mysql_psw=${mysql_psw:=meme}

# Configuration is done.
# Start installing/downloading/setup

START=$(date +%s)

echo "Installing dependencies..."
apt-get update
## SOME UPDATES FOR GCP VPSES OR OTHER VPS PROVIDER
sudo apt-get install build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev -y	 
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
apt-get install python3 python3-dev -y
add-apt-repository ppa:ondrej/php -y
add-apt-repository ppa:longsleep/golang-backports -y
apt-get update
apt install git curl python3-pip python3-mysqldb -y
apt-get install python-dev libmysqlclient-dev nginx software-properties-common libssl-dev mysql-server -y
pip3 install --upgrade pip
pip3 install flask

apt-get install php7.0 php7.0-mbstring php7.0-mcrypt php7.0-fpm php7.0-curl php7.0-mysql golang-go -y

apt-get install composer -y
apt-get install zip unzip php7.0-zip -y
apt-get install redis-server -y

echo "Done installing dependencies!"
mkdir ripple
cd ripple

mkdir nginx
cd nginx
systemctl restart php7.0-fpm
pkill -f nginx
cd /etc/nginx/
rm -rf nginx.conf
wget -O nginx.conf https://github.com/osuryumi/tools/raw/master/etcnginx.conf
sed -i 's#include /root/ripple/nginx/*.conf\*#include '$MasterDir'/nginx/*.conf#' /etc/nginx/nginx.conf
cd $MasterDir
cd nginx
wget -O nginx.conf https://github.com/osuryumi/tools/raw/master/nginx.conf 
sed -i 's#DOMAIN#'$domain'#g; s#DIRECTORY#'$MasterDir'#g; s#6969#'$hanayo_port'#g' nginx.conf
wget -O old-frontend.conf https://github.com/osuryumi/tools/raw/master/old-frontend.conf
sed -i 's#DOMAIN#'$domain'#g; s#DIRECTORY#'$MasterDir'#g; s#6969#'$hanayo_port'#g' old-frontend.conf
wget -O cert.pem https://github.com/osuthailand/ainu-certificate/raw/master/cert.pem
wget -O key.pem https://github.com/osuthailand/ainu-certificate/raw/master/key.key
cd $MasterDir
echo "Nginx has been setup!"

wget -O ripple.sql https://raw.githubusercontent.com/osuryumi/tools/master/dbstructure.sql
mysql -u "$mysql_usr" -p"$mysql_psw" -e 'CREATE DATABASE ripple;'
mysql -u "$mysql_usr" -p"$mysql_psw" ripple < ripple.sql
echo "Database setup is done!"

apt-get install phpmyadmin -y
cd /var/www/
git clone https://github.com/osukawata/old-frontend.git
mv old-frontend osu.ppy.sh
cd osu.ppy.sh
cd inc
mv config.sample.php config.php
sed -i 's#root#'$mysql_usr'#g; s#meme#'$mysql_psw'#g; s#allora#ripple#g; s#ripple.moe#'$domain'#g' config.php
cd ..
composer install
git clone https://github.com/osufx/secret.git
ln -s /usr/share/phpmyadmin phpmyadmin
echo "PHPMyAdmin setup is done!"

cd /root/
git clone https://github.com/Neilpang/acme.sh
apt-get install socat -y
cd acme.sh/
./acme.sh --install
./acme.sh --issue --standalone -d $domain -d c.$domain -d i.$domain -d a.$domain -d old.$domain
echo "Certificate is ready!"

echo "Starting to install server files now!"
cd $MasterDir
git clone https://github.com/osuryumi/pep.py
cd pep.py
git clone https://github.com/osu-minase/secret
git clone https://github.com/osu-minase/common
git submodule init && git submodule update
pip install -r requirements.txt
cd secret
git submodule init && git submodule update
python3.6 setup.py build_ext --inplace
mkdir logs
python3.6 pep.py
sed -i 's#root#'$mysql_usr'#g; s#changeme#'$peppy_cikey'#g'; s#http://.../letsapi#'http://127.0.0.1:5002/letsapi'#g; s#http://cheesegu.ll/api#'https://storage.kurikku.pw/api'#g' config.ini
sed -E -i -e 'H;1h;$!d;x' config.ini -e 's#password = #password = '$mysql_psw'#'
cd $MasterDir
echo "Bancho Server setup is done!"

git clone https://github.com/osuryumi/lets
cd lets
pip install -r requirements.txt
git clone https://github.com/osu-minase/secret
git clone https://github.com/osu-minase/common
cd secret
git submodule init && git submodule update
cd ..
python3.6 setup.py build_ext --inplace
sed -i 's#root#'$mysql_usr'#g; s#mysqlpsw#'$mysql_psw'#g; s#DOMAIN#'$domain'#g; s#changeme#'$peppy_cikey'#g; s#YOUR_OSU_API_KEY_HERE#'$lets_osuapikey'#g; s#http://cheesegu.ll/api#'https://storage.kurikku.pw/api'#g' config.ini
cd /root/ripple
echo "Score Server setup is done!"

go get -u github.com/osuryumi/hanayo
cd ~/go/src/github.com/osuryumi/hanayo
dep init
go build
cd ..
mv hanayo/ ~/root/ripple/hanayo
cd ~/root/ripple/hanayo
sed -i 's#ListenTo=#ListenTo=127.0.0.1:'$hanayo_port'#g; s#AvatarURL=#AvatarURL=https://a.'$domain'#g; s#BaseURL=#BaseURL=https://'$domain'#g; s#APISecret=#APISecret='$hanayo_apisecret'#g; s#BanchoAPI=#BanchoAPI=https://c.'$domain'#g; s#MainRippleFolder=#MainRippleFolder='$MasterDir'#g; s#AvatarFolder=#AvatarFolder='$MasterDir'/nginx/avatar-server/avatars#g; s#RedisEnable=false#RedisEnable=true#g' hanayo.conf
sed -E -i -e 'H;1h;$!d;x' hanayo.conf -e 's#DSN=#DSN='$mysql_usr':'$mysql_psw'@/ripple#'
sed -E -i -e 'H;1h;$!d;x' hanayo.conf -e 's#API=#API=http://localhost:40001/api/v1/#'
echo "Website Server setup is done!"

go get -u github.com/osuryumi/api
dep init
go build
cd ..
mv api/ ~/root/ripple/api
./api
sed -i 's#root@#'$mysql_usr':'$mysql_psw'@#g; s#Potato#'$hanayo_apisecret'#g; s#OsuAPIKey=#OsuAPIKey='$peppy_cikey'#g' api.conf
cd /root/ripple
echo "API setup is done!"

go get -u zxq.co/Sunpy/avatar-server-go
mkdir avatar-server
mkdir avatar-server/avatars
mv /root/go/bin/avatar-server-go ./avatar-server/avatar-server
cd $MasterDir/avatar-server/avatars
# DEFAULT AVATAR
wget -O 0.png https://raw.githubusercontent.com/osuthailand/avatar-server/master/avatars/-1.png
# AC AVATAR
wget -O 999.png https://raw.githubusercontent.com/osuthailand/avatar-server/master/avatars/0.png
cd $MasterDir
echo "Avatar Server setup is done!"

echo "Changing folder and files permissions"
chmod -R 777 /root/ripple

END=$(date +%s)
DIFF=$(( $END - $START ))

nginx
echo "Server setup in $DIFF seconds!"
echo "PHPMyAdmin can be accessed here: http://old.$domain/phpmyadmin"

}
