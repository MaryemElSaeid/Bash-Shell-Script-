###### Module contain the menu driver


###### function displays the menu 
function displayMenu {

	echo "Main Menu"
	echo "-----"
	echo "1-Install Apache Web Server"
	echo "2-Remove a Apache Web Server"
	echo "3-List all Virtual Host"
	echo "4-Add a Virtual Host"
	echo "5-Delete a Virtual Host"
	echo "6-Disable a Virtual Host"
	echo "7-Enable a Virtual Host"
	echo "8-Enable Authentication for a Virtual Host"
	echo "9-Disable Authentication for a Virtual Host"
	echo "10-Quit"
}



######function that checks the existance of apache and if not present installs it
function installApache {

	if [ $(apache2 -v | grep -v grep | grep 'Server version: Apache' | wc -l) = 0 ]
	then
           echo "Installing Apache."
	      sudo apt apache2 install
        else
	   echo "Appache is already installed."
	fi

}

###function that removes apache 
function deleteApache {
       
	if [ $(apache2 -v | grep -v grep | grep 'Server version: Apache' | wc -l) = 0 ]
	then
	   
	   echo "Apache is not installed"
	   
        
        else
	
             echo "Deleting Apache Web Server ......."
             sudo apt remove apache2
	 fi

}


####function that lists all virtual hosts to the std/output
function displayAllHosts {
   
ls /etc/apache2/sites-available

}


####function that reads hostname 
function readVirtualHostName {

	read -p "Enter Virtual Host Name :" HOSTNAME
	

}

#####function that adds a virtual host
function addVirtualHost {
  
        sudo mkdir /var/www/html/${HOSTNAME}.com
	
	cd /var/www/html/${HOSTNAME}.com/
	echo "${HOSTNAME}.com" > index.html


	cd /etc/apache2/sites-available/
	echo "  
	 

        	<VirtualHost *:80>
       		 DocumentRoot /var/www/html/${HOSTNAME}.com
		 ServerName ${HOSTNAME}.com
	      </VirtualHost>
	      <Directory /var/www/html/${HOSTNAME}.com>
	         Options ALL
	         AllowOverride All
	         Require all granted
	       </Directory>	" > ${HOSTNAME}.com.conf

	sudo a2ensite ${HOSTNAME}.com
	cd /mnt/c/Windows/System32/drivers/etc/
	sudo echo "127.0.0.1	${HOSTNAME}.com" >> hosts 
	sudo service apache2 restart 
}



###function that enable virtual host 
function enableVirtualHost {
      
      sudo a2ensite ${HOSTNAME}.com.conf
      sudo /etc/init.d/apache2 reload

}



####function that disable a virtual host
function disableVirtualHost {
    
    sudo a2dissite ${HOSTNAME}.com.conf
    sudo /etc/init.d/apache2 reload

}

########function that deletes virtual host 
function deleteVirtualHost {
    
    cd /etc/apache2/sites-available/
    sudo rm ${HOSTNAME}.com.conf
    cd 
    cd /var/www/html
    sudo rm ${HOSTNAME}.com/index.html

}

########function that adds authentication to your webs
function enableAuthen {
	
	 cd
         cd /etc/apache2/
	 if [ $(ls -a | grep '.htpasswd' | wc -l) =  0 ]
         then
	     read -p "Enter User Name :" USERNAME
	     sudo htpasswd -c /etc/apache2/.htpasswd ${USERNAME}
         

         else
	 echo ".htpasswd already exists"
	 fi

	cd 
        cd /var/www/html	
	if [ $(ls -a | grep '.htaccess' | wc -l) = 0 ]
	then
		
                sudo nano /var/www/html/.htaccess
	else
		echo ".htaccess already exists"
	fi
        
	
	cd
	cd /var/www/html/
        echo " AuthType Basic
	AuthName \"Restricted Content\"
	AuthUserFile /etc/apache2/.htpasswd
	Require valid-user " > .htaccess
	
        cd 
	cd /etc/apache2/sites-available/
	echo "


	<VirtualHost *:80>
	    DocumentRoot /var/www/html/${HOSTNAME}.com
	    ServerName ${HOSTNAME}.com
	</VirtualHost>
	<Directory /var/www/html/${HOSTNAME}.com>
           Options ALL
           AllowOverride All
           Require valid-user
        </Directory>     " > ${HOSTNAME}.com.conf
        
	cd 
	sudo service apache2 restart  	
} 

function disableAuthen {

        cd
	cd /etc/apache2/sites-available/
        echo "


        <VirtualHost *:80>
            DocumentRoot /var/www/html/${HOSTNAME}.com
	    ServerName ${HOSTNAME}.com
        </VirtualHost>
        <Directory /var/www/html/${HOSTNAME}.com>
	    Options ALL
	    AllowOverride All
	    Require all granted
	</Directory>     " > ${HOSTNAME}.com.conf

	cd
	sudo service apache2 restart


}

###function that runs menu 
function runMenu {

	local CH
	local FLAG=1
	
	while [ ${FLAG} -eq 1 ]
	do
		echo "Enter your choice"
		read CH
		case ${CH} in 
			"1")
				installApache
				;;
			"2")
				echo "Deleting Apache"
                deleteApache
				;;
			"3")
				displayAllHosts
				;;
			"4")
				readVirtualHostName
			        addVirtualHost	
				;;
			"5")
				readVirtualHostName
				deleteVirtualHost
				;;
		        "6")
				readVirtualHostName
				disableVirtualHost
			      	;;

			"7")
			    readVirtualHostName
				enableVirtualHost
				;;
			"8")    
				readVirtualHostName
				enableAuthen
				;;
			"9")
				readVirtualHostName
				disableAuthen
				;;

			"10")
				FLAG=0
				;;
			*)
			echo "Invalid Choice , Please enter a valid number"
			        ;;
                esac  
         
	done

}


