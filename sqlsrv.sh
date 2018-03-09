#!/bin/bash
#Instalar el Repositorio Epel-Release
yum -y install epel-release
#Instalar Repositorio de Microsoft Para compatibilidad de DriverODBC 13.0
curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
 yum remove unixODBC #to avoid conflicts
#Instalacion de ODBC Driver 13.0
ACCEPT_EULA=Y yum install msodbcsql-13.0.1.0-1 mssql-tools-14.0.2.0-1
yum install  -y unixODBC-utf16-devel
yum install unixODBC-utf16-devel #this step is optional but recommended*
#Instalacion de Apache Servidor Web
yum install -y httpd
#Instalacion de Repositorio Webtatic
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
#Instalacion de PHP 7 Centos
yum install -y php70w php70w-common php70w-devel php70w-cli php70w-mysql php70w-odbc
#Verificacion de PHP
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Verificamos que nuestra version de php sea la 7
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"
php --version
sleep 5
#Instalar Compilador de C
yum install -y gcc-c++
#Condicional que me verificara si cuento con el Archivo msphpsql-4.0.6-Linux.zip que me contendra los archivos para compilar SQLSRV
echo "A partir de aqui debes de Tener msphpsql-4.0.6-Linux.zip descargado, si no es asi favor descargalo en la ruta Downloads/ "
echo "En caso de Ser Afirmativa tu Respuesta por favor escribe si"
sleep 5
read "con"
if [ "$con" = "si" ]; then
#Accedemos al Directorio /Downloads para descomprimir nuestro archivo msphpsql-4.0.6-Linux.zip
cd Downloads/
unzip msphpsql-4.0.6-Linux.zip 
cd msphpsql-4.0.6-Linux/source/sqlsrv/
#Compilamos dentro del Directorio msphpsql-4.0.6-Linux/source/sqlsrv/
phpize
./configure
sleep 5
make
sleep 5
make install
sleep 5
echo "  
extension=sqlsrv.so" >> /etc/php.ini 
touch /var/www/html/index.php
echo "<?php  // Muestra toda la información, por defecto INFO_ALL  
phpinfo(); 
?>" > /var/www/html/index.php

#Por Ultimo Iniciamos el Servicio de Apache
systemctl restart httpd.service

elif [ "$con" = "no" ]; then
echo "Usted ha cancelado la Instalacion de SQLSRV para Linux"
sleep 5
exit
else
echo "usted ha ingresado valores diferentes de si/no"
echo "Usted ha cancelado la Instalacion de SQLSRV para Linux"
sleep 5
exit
fi

#Desarrolado por Jose Beltre & Maher Sanchez
