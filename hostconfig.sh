#!/bin/sh
#This script generates hostinfo file for Hypori clients

file=hostinfo.yaml

rm $file
touch $file

echo What hosts are we going to provision
echo "========================================="
{
echo "hosts :
  #ADD CONFIGURED HOSTNAME THAT YOU WANT TO DEPLOY HERE"
} >> $file
read -rp "Are you deploying a controller vm y\n: " cy_vm
if [ "$cy_vm" = y ]
then 
	read -rp "What is the Controller's Domain Name: " con_domain
	echo "   - $con_domain" >> $file
fi
if [ "$cy_vm" = n ]
then
	echo "   #-controller.droidcloud.mobi" >> $file
fi
read -rp "Are you deploying a compute node y\n: " cn_vm
if [ "$cn_vm" = y ]
then
	read -rp "What is the Compute Nodes Domain Name: " com_domain
	echo "   - $com_domain" >> $file
fi
if [ "$cn_vm" = n ]
then
	echo "   #-compute.droidcloud.mobi" >> $file
fi
read -rp "Are you deploying a management vm y\n: " my_vm
if [ "$my_vm" = y ]
then
	read -rp "What is the Management Server's Domain Name: " man_domain
	echo "   - $man_domain" >> $file
fi
if [ "$my_vm" = n ]
then
	echo "   #- management.droidcloud.mobi" >> $file
fi
read -rp "Are you deploying a storage vm for NFS storage y\n: " sy_vm
if [ "$sy_vm" = y ]
then
	read -rp "What is the Storage Server's Domain Name: " sto_domain
	echo "   - $sto_domain" >> $file
fi
if [ "$sy_vm" = n ]
then
	echo "   #- storage.droidcloud.mobi" >> $file
fi
echo
echo "" >> $file
echo "#Controller" >> $file 
if [ "$cy_vm" = n ]
then
	{
    echo "#controller.droidcloud.mobi	
	#  hostinfo:
	#    macaddr   : \"506b8dd8d819\"
	#    build     : true
	#    hostgroup : \"HyporiController\"
	#    ipaddress : \"10.40.21.12\"
	
	#  puppet_config_info:
	#    profile::controller::disable_puppet_run  : false
	#    role::controller::controller_ip          : \"10.40.21.12\"
	#    controller::custom_modules :
	#        #- profile::apps::controller::nagiosapp
	#        #- profile::apps::controller::nagiosnrpe
	#        - profile::apps::snmpapp"
    } >> $file
fi
if [ "$cy_vm" = y ]
then
    echo "==================Controler Settings=============="	
    echo "$con_domain" >> $file
	echo Controler VM information
	read -rp "What is the mac address for the interface of the Controller VM on the Management Network: " con_mac
	read -rp "Do you want to build the controller vm true\false: " con_build
	read -rp "What should the host name be for the copmute vm. Default is HyporiController: " conh_name
	read -rp "What is the IP for the Controller VM on the Management Network: " con_ip
 	read -rp "Do you want to disable puppet run on the Controller VM true\false: " con_puppet
	echo	
	echo "============Controller information confirmation================="
	echo "hostinfo:" >> $file
	echo "Controller vm's mac address is $con_mac"
	read -rp "Is this correct y\n: " cm_an
	if [ "$cm_an" = y ]
	then
		echo "    macaddr   : \"$con_mac"\" >> $file
	else
		read -rp "What is the Controller vm's mac address: " con_mac
		echo "  macaddr   : \"$con_mac"\" >> $file
	fi
	echo "Build Controller vm is currently set to $con_build"
	read -rp "Is this correct y\n: " cb_an
	if [ "$cb_an" = y ]
	then
		echo "    build     : $con_build" >> $file
	else
		read -rp "Do you want to build the Cotroller VM: " con_build
		echo "    build     : $con_build" >> $file
	fi
	echo "Controller VMs hostname is $conh_name" 
	read -rp "Is this correct y\n: " ch_an
	if [ "$ch_an" = y ]
	then
		echo "    hostgroup : \"$conh_name"\" >> $file
	else 
		read -rp "What should the Controller VMs hostname be: " conh_name
		echo "    hostgroup : \"$conh_name"\" >> $file
	fi
	echo "Controller VMs IP is $con_ip"
	read -rp "Is this correct y\n: " ci_an
	if [ "$ci_an" = y ]
	then
		echo "    ipaddress : \"$con_ip"\" >> $file
	else 
		read -rp "What is the Controller VMs IP: " con_ip
		echo "    ipaddress : \"$con_ip"\" >> $file
	fi
	echo "" >> $file
	echo "  puppet_config_info:" >> $file
	echo "Puppet run is currently set to $con_puppet"
	read -rp "Is this correct y\n: " cp_an
	if [ "$cp_an" = y ]
	then
		echo "    profile::controller::disable_puppet_run  : $con_puppet" >> $file
	else
		read -rp "Pupper run on the controller set to true\false:" con_puppet
		echo "    profile::controller::disable_puppet_run  : $con_puppet" >> $file
	fi
	{
    echo "    role::controller::controller_ip          : \"""$con_ip""\"
controller::custom_modules ::
	     #- profile::apps::controller::nagiosapp
	     #- profile::apps::controller::nagiosnrpe
	      - profile::apps::snmpapp"
    }>> $file
fi
echo
echo "" >> $file
echo "# Compute" >> $file
if [ "$cn_vm" = n ]
then 
    {	
    echo "#compute.droidcloud.mobi:
  	#hostinfo:
	#    macaddr   : \"e4434b23d2ec\" 
	#    build     : true
	#    hostgroup : \"HyporiCompute\"
	#    ipaddress : \"10.40.21.30\"
	
	#  puppet_config_info:
	#    profile::compute::disable_puppet_run : false
	#    profile::compute::controller_ip      : \"10.40.21.12\" 
	#    profile::compute::hostnet::ent_ip    : \"10.40.23.30\" 
	#    profile::compute::hostnet::ent_if    : \"eth2\"
	#    profile::compute::compute_ip         : \"10.40.21.30\"
	#    profile::compute::hostnet::display_if    : \"eth1\"
	#    profile::compute::hostnet::display_ip    : \"10.40.22.30\"
	#    role::compute::storage_host: \"storage.droidcloud.mobi\"
	     # Uncomment these tokens only if using local storage\"
	     #profile::compute::cinder::provision_volume_service : true
	#    role::compute::storage_nfs_share: \"ntxstor.droidcloud.mobi:/ntxstor\"
	     #role::compute::storage_type: \"local_iscsi\"
	     ## comment out below if you want snmp monitoring disabled
	#    profile::compute::nfs_mount_options: \"rw,hard,intr,retrans=3,proto=tcp,sec=sys,vers=4\"
	#    role::compute::storage_type: \"nfs\" 
	#    profile::compute::hostnet::cust_net_if: \"eth3\" 
	#    profile::compute::hostnet::cust_net_mask: \"255.255.255.0\" 
	#    profile::compute::hostnet::cust_net_gwy: \"10.40.25.1\"
	#    profile::compute::hostnet::cust_net_ip: \"10.40.25.30\" 
	     #profile::compute::hostnet::cust_net_vlan_present: false
	     #profile::compute::hostnet::cust_net_vlan_tag: 0
	#    compute::custom_modules :
	         #- profile::apps::compute::nrpe
    #        - profile::apps::snmpapp"
    }>> $file
fi
if [ "$cn_vm" = y ]
then
	echo "=============Compute Node Configuration============"
	echo "$com_domain" >> $file
	echo Compute Node Information
	read -rp "What is the mac address for the interface on the Compute Node on the Management Network?: " com_mac
	read -rp "Do you want the Compute Node to be built true\false: " com_build
	read -rp "What is the Compute Nodes host name?: " com_host
	read -rp "What is the Compute Nodes IP on the Management Network?: " com_ip
	read -rp "Should puppet run be disabled on the Compute Node true\false: " com_puppet
	read -rp "What is the Compute Nodes IP on the Enterprise network?: " com_enip
	read -rp "What is the Compute Nodes IP on the Display network?: " com_diip
        read -rp "Are you using vlan tagging for the Compute Node true\false: " com_tag
	if [ "$com_tag" = "true" ]
	then
		read -rp "What interface is being used on the Compute Node: " com_int
		read -rp "What is the vlan ID for Enterprise network?: " ent_tag
        read -rp "What is the vlan ID for the Display network?: " dis_tag
	fi
    if [ "$com_tag" = "false" ]
    then
		read -rp "What interface will be used for the Enterprise network?: " ent_int
        read -rp "what interface will be used for the Display Network?: " dis_int
	fi
	read -rp "What type of storage will be used local\NFS?: " com_stor
	if [ "$com_stor" = NFS ] && [ "$sy_vm" = y ]
	then
		read -rp "What is the NFS share name?: " stor_nfs
		read -rp "What is the Compute Nodes storage network IP?: " com_stip
		read -rp "What is the Storage Networks netmask?: " stor_netmask
		read -rp "What is the Storage Networks gateway?: " stor_gate
		if [ "$com_tag" = "true" ]
		then	
			read -rp "What is the storage vlan ID?: " stor_vlan
		fi
    else
        if [ "$com_stor" = NFS ] && [ "$sy_vm" = n ]
	then
	    	echo "You have chosen not to provision a Storage VM which is needed to use NFS storage."
            read -rp "Would you like to provision out a Storage VM y\n: " sy_vm
            if [ $sy_vm = y ]
            then
                read -rp "What is the NFS share name?: " stor_nfs
		        read -rp "What is the Compute Nodes storage network IP?: " com_stip
		        read -rp "What is the Storage Networks netmask?: " stor_netmask
		        read -rp "What is the Storage Networks gateway?: " stor_gate
		        if [ "$com_tag" = "true" ]
		        then	
			        read -rp "What is the storage vlan ID?: " stor_vlan
		        fi
            fi
	fi
    if [ "$com_stor" = "local" ] && [ "$sy_vm" = y ]
    then
    	    echo "You have chossen to deploy the storage locally on the Compute node and are also deploying a Storage VM for NFS storage."
            read -rp "Would you like to continue to use local storage and not deploy a Storage VM y\n: " storage_an
            if [ "$storage_an" = y ]
            then
                sy_vm=n
            fi
            if [ "$storage_an" = n ]
            then
                echo "Please ensure you change your choise of storage during confirmation."
            fi
    fi
fi
	echo
	echo "=================Compute Node Configuration Confirmation===================="
	echo "  hostinfo:" >> $file
	echo "Compute nodes mac address is set to $com_mac"
	read -rp "Is this correct y\n: " ccma_an
	if [ "$ccma_an" = y ]
	then
		echo "    macaddr   : \"$com_mac"\" >> $file
	else
		read -rp "What is the mac address for the interface on the Compute Node on the Management Network?: " com_mac
		echo "    macaddr   : \"$com_mac"\" >> $file
	fi
	echo "Compute node build status is set to $com_build"
	read -rp "Is this correct y\n: " ccb_an
	if [ "$ccb_an" = y ]
	then
		echo "    build     : $com_build" >> $file
	else 
		read -rp "Do you want the Compute Node to be built true\false: " com_build
		echo "    build     : $com_build" >> $file
	fi
	echo "Compute nodes host name is set to $com_host"
	read -rp "Is this correct y\n: " cch_an
	if [ "$cch_an" = y ]
	then
		echo "    hostgroup : \"$com_host"\" >> $file
	else
		read -rp "What is the Compute Nodes host name?: " com_host
		echo "    hostgroup : \"$com_host"\" >> $file
	fi
	echo "Compute nodes management IP is currently set to $com_ip"
	read -rp "Is this correct y\n: " ccip_an
	if [ "$ccip_an" = y ]
	then
		echo "    ipaddress : \"$com_ip"\" >> $file
	else
		read -rp "What is the Compute Nodes IP on the Management Network?: " com_ip
		echo "    ipaddress : \"$com_ip"\" >> $file
	fi
	echo "" >> $file
	echo "  puppet_config_info:" >> $file
	echo "Puppet run is currently set to $com_puppet"
	read -rp "Is this correct y\n: " ccp_an
	if [ "$ccp_an" = y ]
	then
		echo "    profile::compute::disable_puppet_run : $com_puppet" >> $file
	else
		read -rp "Should puppet run be disabled on the Compute Node true\false: " com_puppet
		echo "    profile::compute::disable_puppet_run : $com_puppet" >> $file
	fi
	echo "    profile::compute::controller_ip      : \"$con_ip"\" >> $file
	echo "    profile::compute::compute_ip         : \"$com_ip"\" >> $file
	echo "Compute nodes Enterprise Network IP is set to $com_enip" 
	read -rp "Is this correct y\n: " cceip_an
	if [ "$cceip_an" = y ]
	then
		echo "    profile::compute::hostnet::ent_ip    : \"$com_enip"\" >> $file
	else
		read -rp "What is the compute nodes Enterprise IP: " com_enip
		echo "    profile::compute::hostnet::ent_ip    : \"$com_enip"\" >> $file
	fi
	if [ "$com_tag" = "false" ]
    then
        echo "Compute nodes Enterprise network adapter is set to $ent_int"
	    read -rp "Is this correct y\n: " cceit_an
	    if [ "$cceit_an" = y ]
	    then
		    echo "    profile::compute::hostnet::ent_if    : \"$ent_int"\" >> $file
	    else
		    read -rp "What interface will be used for the Enterprise network?: " ent_int
		    echo "    profile::compute::hostnet::ent_if    : \"$ent_int"\" >> $file
	    fi
    fi
	echo "Compute node vlan tagging is currently set to $com_tag"
	read -rp "Is this correcet y\n: " cct_an
	if [ "$cct_an" = y ] && [ "$com_tag" = "true" ]
	then
		echo "    profile::compute::hostnet::ent_vlan_present: $com_tag" >> $file
		echo "Enterprise VLAN ID is currently set to $ent_tag"
		read -rp "Is this correcty y\n: " ccet_an
		if [ "$ccet_an" = y ]
		then
			echo "    profile::compute::hostnet::ent_vlan_tag: $ent_tag" >> $file
		else 
			read -rp "What is the vlan ID for Enterprise network?: " ent_tag
			echo "    profile::compute::hostnet::ent_vlan_tag: $ent_tag" >> $file
		fi
        echo "    profile::compute::hostnet::ent_if    : \"$com_int"\" >> $file
	else
		if [ "$cct_an" = y ] && [ "$com_tag" = "false" ]
		then
			echo "    profile::compute::hostnet::ent_vlan_present: $com_tag" >> $file
			echo "#    profile::compute::hostnet::ent_vlan_tag: $ent_tag" >> $file
		else
			if [ "$cct_an" = n ] && [ "$com_tag" = "false" ]
			then
				read -rp "Are you using vlan tagging for the Compute Node true\false: " com_tag
				echo "    profile::compute::hostnet::ent_vlan_present: $com_tag" >> $file
				read -rp "What is the vlan ID for Enterprise network?: " ent_tag
				echo "    profile::compute::hostnet::ent_vlan_tag: $ent_tag" >> $file
			else
				if [ "$cct_an" = n ] && [ "$com_tag" = "true" ]
				then
					com_tag="false"		
					echo "    profile::compute::hostnet::ent_vlan_present: $com_tag" >> $file
					echo "#    profile::compute::hostnet::ent_vlan_tag: $ent_tag" >> $file
				fi
			fi
		fi
	fi
	echo "The compute nodes Display Network IP is $com_diip"
	read -rp "Is this correct y\n: " ccdi_an
	if [ "$ccdi_an" = y ]
	then
		echo "    profile::compute::hostnet::display_ip    : \"$com_diip"\" >> $file
	else
		read -rp "What is the Compute Nodes IP on the Display network?: " com_diip
		echo "    profile::compute::hostnet::display_ip    : \"$com_diip"\" >> $file
	fi
    if [ $com_tag = "false" ]
    then	
        echo "The Compute nodes Display network addapter is $dis_int"
	    read -rp "Is this correct y\n: " ccdint_an
	    if [ "$ccdint_an" = y ]
	    then
		    echo "    profile::compute::hostnet::display_if    : \"$dis_int"\" >> $file
	    else 
		    read -rp "what interface will be used for the Display Network?: " dis_int
		    echo "    profile::compute::hostnet::display_if    : \"$dis_int"\" >> $file
	    fi
    fi
	if [ "$cct_an" = y ] && [ $com_tag = "true" ]
	then
		echo "    profile::compute::hostnet::display_vlan_present: $com_tag" >> $file
		echo "Display VLAN ID is currently set to $dis_tag"
		read -rp "Is this correcty y\n: " ccdt_an
		if [ "$ccdt_an" = y ]
		then
			echo "    profile::compute::hostnet::display_vlan_tag: $dis_tag" >> $file
		else
			read -rp "What is the vlan ID for the Display network?: " dis_tag
			echo "    profile::compute::hostnet::display_vlan_tag: $dis_tag" >> $file
		fi
        echo "    profile::compute::hostnet::display_if    : \"$com_int"\" >> $file
	else
		if [ "$cct_an" = y ] && [ $com_tag = "false" ]
		then
			echo "    profile::compute::hostnet::display_vlan_present: $com_tag" >> $file
			echo "#    profile::compute::hostnet::display_vlan_tag: $dis_tag" >> $file
		else
			if [ "$cct_an" = n ] && [ $com_tag = "false" ]
			then
				read -rp "Are you using vlan tagging for the Compute Node true\false: " com_tag
				echo "    profile::compute::hostnet::display_vlan_present: $com_tag" >> $file
				read -rp "What is the vlan ID for the Display network?: " dis_tag
				echo "    profile::compute::hostnet::display_vlan_tag: $dis_tag" >> $file
		else
				if [ "$cct_an" = n ] && [ "$com_tag" = "true" ]
				then
					com_tag="false"		
					echo "    profile::compute::hostnet::display_vlan_present: $com_tag" >> $file
					echo "#    profile::compute::hostnet::display_vlan_tag: $dis_tag" >> $file
				fi
			fi
		fi
	fi
	echo "Compute nodes storage type is set to $com_stor"
	read -rp "Is this correct y\n: " ccst_an
	if [ "$ccst_an" = y ] && [ "$com_stor" = "NFS" ]
	then
		echo "Compute nodes Storage IP is set to $com_stip"
		read -rp "Is this correct y\n: " ccsti_an
		if [ "$ccsti_an" = y ]
		then
			echo "    profile::compute::hostnet::cust_net_ip: \"$com_stip"\" >> $file
		else 
			read -rp "What is the compute nodes Storage IP: " com_stip
			echo "    profile::compute::hostnet::cust_net_ip: \"$com_stip"\" >> $file
		fi
		echo "Compute nodes Storage Gateway is set to $stor_gate"
		read -rp "Is this correct y\n: " ccsg_an
		if [ "$ccsg_an" = y ]
		then
			echo "    profile::compute::hostnet::cust_net_gwy: \"$stor_gate"\" >> $file
		else
			read -rp "What is the Storage Networks Gateway IP: " stor_gate
			echo "    profile::compute::hostnet::cust_net_gwy: \"$stor_gate"\" >> $file
		fi
		echo "Compute nodes Storage Networks Netmask is set to $stor_netmask"
		read -rp "Is this correct y\n: " ccsn_an
		if [ "$ccsn_an" = y ]
		then
			echo "    profile::compute::hostnet::cust_net_mask: \"$stor_netmask"\" >> $file
		else
			read -rp "What is the Storage Networks netmask: " stor_netmask
			echo "    profile::compute::hostnet::cust_net_mask: \"$stor_netmask"\" >> $file
		fi
		echo "Storage VMs name is setup to $sto_domain"
		read -rp "Is this correcty y\n: " sd_an
		if [ "$sd_an" = y ]
		then
			echo "    role::compute::storage_host: $sto_domain" >> $file
		else
			read -rp "What is the Storage VMs domain name: " sto_domain
			echo "    role::compute::storage_host: $sto_domain" >> $file
		fi
		echo "NFS share is set to $stor_nfs"
		read -rp "Is this correct y\n: " sn_an
		if [ "$sn_an" = y ]
		then
			echo "    role::compute::storage_type: \"$stor_nfs"\" >> $file
		else
			echo "If this is changed then you will will be using local storage"
			read -rp "Do you want to do this: " snc_an
			if [ "$snc_an" = y ]
			then
				{
                   echo "   # Uncomment these tokens only if using local storage
	        	        profile::compute::cinder::provision_volume_service : true
			            role::compute::storage_type: \"local_iscsi\""
                }>> $file
			fi
		fi
		echo "    profile::compute::nfs_mount_options: \"rw,hard,intr,retrans=3,proto=tcp,sec=sys,vers=4"\" >> $file
		if [ "$cct_an" = y ] && [ $com_tag = "true" ]
		then
			echo "    profile::compute::hostnet::cust_net_vlan_present: $com_tag" >> $file
			echo "Storage VLAN ID is currently set to $stor_vlan"
			read -rp "Is this correcty y\n: " ccsv_an
			if [ "$ccsv_an" = y ]
			then
				echo "    profile::compute::hostnet::cust_net_vlan_tag: $stor_vlan" >> $file
			else 
				read -rp "What is the Storage VLAN ID: " ent_tag
				echo "    profile::compute::hostnet::cust_net_vlan_tag: $stor_vlan" >> $file
			fi
		else
			if [ "$cct_an" = y ] && [ $com_tag = "false" ]
			then
				{
                echo "    profile::compute::hostnet::cust_net_vlan_present: $com_tag
				#    profile::compute::hostnet::cust_net_vlan_tag: $stor_vlan"
                }>> $file
			fi
		fi
	else
        	if [ "$ccst_an" = y ] && [ "$com_stor" = "local" ]
        	then
	        	{
                echo "    # Uncomment these tokens only if using local storage
	        profile::compute::cinder::provision_volume_service : true
		    role::compute::storage_type: \"local_iscsi\"" 
                }>> $file
	       	fi
	fi
    {	
    echo "    ## comment out below if you want snmp monitoring disabled
	compute::custom_modules :
         #- profile::apps::compute::nrpe
	      - profile::apps::snmpapp"
    } >> $file
fi
echo "" >> $file
echo "Management" >> $file
if [ "$my_vm" = n ]
then
    {
        echo "	#management.droidcloud.mobi:
	 #  hostinfo:
	 #    macaddr   : \"506b8d9379de\"
	 #    build     : true
	 #    hostgroup : \"HyporiManagement\" 
	 #    ipaddress : \"10.40.21.10\"
	
	  #puppet_config_info:
	    #profile::mgmt::disable_puppet_run     : false
	    #profile::mgmt::mgmt_ip                : \"10.40.21.10\"
	    #profile::mgmt::mgmtconfig::auth_url   : \"http://10.40.21.12:5000/v2.0/\" 
	    #profile::mgmt::hostnet::display_ip    : \"10.40.22.10\" 
	    #profile::mgmt::hostnet::display_if    : \"eth1\" 
	    #profile::mgmt::mgmtconfig::cipherlist : \"!aNULL:!eNULL:FIPS\"
	    #profile::mgmt::enable_client_signing  : true
	
	    # Fully-qualified external DNS name pointing to the Hypori Admin Console
	    # (This setting is not required, but should be populated for reference.)
	    #profile::mgmt::ext_mgmt_fqdn: \"management.droidcloud.mobi\"
	
	    # These settings are required, and must be different from 'ext_mgmt_fqdn' set above.
	    # Fully-qualified external DNS name pointing to the user provisioning application
	    #profile::mgmt::ext_userprov_fqdn: \"hypauth.droidcloud.mobi\" 
	    # Fully-qualified external DNS name pointing to the client authentication endpoint
	    #profile::mgmt::ext_auth_fqdn: \"hypauth.droidcloud.mobi\"
	    # Fully-qualified external DNS name pointing to the client notification endpoint
	    #profile::mgmt::ext_notify_fqdn: \"hypauth.droidcloud.mobi\"
	
	    # Set only if the external domain for compute nodes is not 'droidcloud.mobi'
	    # (This does not apply to any of the FQDNs above, only to compute node names.)
	    #profile::mgmt::rewrite_domain_name   : \"acme.com\" 
	
	    # Uncomment if management role needs to be connected to enterprise network also
	    #profile::mgmt::hostnet::ent_if : \"eth2\"
	    #profile::mgmt::hostnet::ent_ip : \"10.40.23.10\"
	
	    # Uncomment if the management server is behind a TLS proxy
	    #profile::mgmt::trusted_proxies:
	    #    - \"127.0.0.1\"        # Add a line like this one for each internal IP address of a trusted proxy server
	    #    - \"10.40.24.0/24\"   # Subnets are OK as well
	
	    # push notifications enable/disable and polling interval
	    #profile::mgmt::pushnotifications_enable: false
	    #profile::mgmt::silent_pushnotifications: true
	    #profile::mgmt::pollnotifications_interval: 90
	    #profile::mgmt::pushnotifications_env: prod
	    #profile::mgmt::pushnotifications_gcm_api_key: \"<customer-GCM-project-server-api-key>\"
	    #profile::mgmt::pushnotifications_gcm_sender_id: \"<customer-GCM-project-sender-id>\"
	    #profile::mgmt::pushnotifications_apn_prodcert_password: \"<customer-CBS-client-APN-prodcert-password>\" 
	    #profile::mgmt::mgmtconfig::pushnotifications_apn_sandboxcert_password: \"<customer-CBS-client-APN-sandboxcert-password>\"
	    ## comment out below if you want snmp monitoring disabled
	    #mgmt::custom_modules :
	        #- profile::apps::snmpapp"
    } >> $file
fi
echo
if [ "$my_vm" = y ]
then
	echo "============Management Server Configuration=============="
	echo "$man_domain:" >> $file
	echo " hostinfo: " >> $file
	read -rp "What is the mac address of the interface of the Management VM on the Management Network: " ma_mac
	read -rp "Should we build the Management VM true\false: " ma_build
	read -rp "What is the hostname of the Management VM: " ma_host
	read -rp "What is the IP for the Management VM on the Management Network: " ma_ip
	read -rp "Should puppet be excluded to run on the Management VM true\false: " ma_puppet
	read -rp "What is the IP for the Management VM IP on the Display Network: " mad_ip
	read -rp "What is the interface on Management VM for the Display Network: " mad_int
	read -rp "Should we enable client signing true\false: " ma_sign
	read -rp "What is the external FQDN for the Management VM: " ma_fqdn
	read -rp "What is the external FQDN for User Provisioning: " ma_pro
	read -rp "What is the external FQDN for User Authentication: " ma_auth
	read -rp "What is the external FQDN for Notification: " ma_not
	read -rp "What is the external rewrite for the Compute Node: " ma_rew
	read -rp "Does the Management VM need to connect to the Enterprise Network y\n: " ma_ent
	if [ "$ma_ent" = y ]
	then 
		read -rp "What is the interface on the Management VM that connects to the Enterprise Network: " mae_int
		read -rp "What is the IP for the Management VMs on the Enterprise Network: " mae_ip
	fi
	read -rp "Is a proxy being used for this install y\n: " ma_prox
	if [ "$ma_prox" = y ]
	then
		read -rp "Do you want to allow a subnet or a single IP for the proxy subnet\single: " mas_an
		if [ "$mas_an" = subnet ]
		then
			read -rp "What is the subnet of the Proxy: " ma_sub
		else
			if [ "$mas_an" = single ]
			then
				read -rp "What is the IP of the Proxy: " ma_sin
			fi
		fi
	fi
	read -rp "Enable push notification true\false: " ma_push
	read -rp "Enable silent push notification true\false: " ma_silent
	if [ "$ma_push" = "true" ]
	then
		read -rp "What interval do you want for notifications in seconds: " map_time
	fi
	echo 
	echo "====================Management Server Configuration Confirmation============="
	echo "Management VMs mac address is set to $ma_mac"
	read -rp "Is this correct y\n: " mm_an
	if [ "$mm_an" = y ]
	then
		echo "    macaddr   : \"$ma_mac"\" >> $file
	else
		read -rp "What is the mac address of the Management VM: "
		echo "    macaddr   : \"$ma_mac"\" >> $file
	fi
	echo "Management VM build status is set to $ma_build"
	read -rp "Is this correct y\n: " mb_an
	if [ "$mb_an" = y ]
	then
		echo "    build     : $ma_build" >> $file
	else
		read -rp "Should we build Management VM true\false: " ma_build
		echo "    build     : $ma_build" >> $file
	fi
	echo "Management VM host name is set to $ma_host"
	read -rp "Is this correct y\n: " mh_an
	if [ "$mh_an" = y ]
	then
		echo "    hostgroup : \"$ma_host"\" >> $file
	else
		read -rp "What is the hostname of the Management VM: " ma_host
		echo "    hostgroup : \"$ma_host"\" >> $file
	fi
	echo "Management VMs IP on the Management Network is set to $ma_ip"
	read -rp "Is this correct y\n: " my_an
	if [ "$my_an" = y ]
	then
		echo "    ipaddress : \"$ma_ip"\" >> $file
	else
		read -rp "What is the Management VMs management network IP: " ma_ip
		echo "    ipaddress : \"$ma_ip"\" >> $file
	fi
	echo "" >> $file
	echo "  puppet_config_info:" >> $file
	echo "Puppet run on Management Vm is set to $ma_puppet"
	read -rp "Is this correct y\n: " mp_an
	if [ "$mp_an" = y ]
	then
		echo "    profile::mgmt::disable_puppet_run     : $ma_puppet" >> $file
	else 
		read -rp "Should puppet not run on the Management server true\false: " ma_puppet
		echo "    profile::mgmt::disable_puppet_run     : $ma_puppet" >> $file
	fi
	echo "    profile::mgmt::mgmtconfig::auth_url   : \"http://$con_ip:5000/v2.0/"\" >> $file
	echo "Management VMs display IP is set to $mad_ip"
	read -rp "Is this correct y\n: " md_ip
	if [ "$md_ip" = y ]
	then
		echo "    profile::mgmt::hostnet::display_ip    : \"$mad_ip"\" >> $file
	else
		read -rp "What is the Management VMs Display network IP?" mad_ip
		echo "    profile::mgmt::hostnet::display_ip    : \"$mad_ip"\" >> $file
	fi
	echo "Management VMs Display Network addapter is set to $mad_int"
	read -rp "Is this correct y\n: " mi_an
	if [ "$mi_an" = y ]
	then
		echo "    profile::mgmt::hostnet::display_if    : \"$mad_int"\" >> $file
	else
		read -rp "What is the interface for the Management VM on the Display Network: " mad_int
		echo "    profile::mgmt::hostnet::display_if    : \"$mad_int"\" >> $file
	fi
	echo "    profile::mgmt::mgmtconfig::cipherlist : \"!aNULL:!eNULL:FIPS"\" >> $file
	echo "Client signed is set to $ma_sign"
	read -rp "Is this correct y\n: " ms_an
	if [ "$ms_an" = y ]
	then
		echo "    profile::mgmt::enable_client_signing  : $ma_sign" >> $file
	else
		read -rp "Should host signed be set true\false: " ma_sign
		echo "    profile::mgmt::enable_client_signing  : $ma_sign" >> $file
	fi
    echo "" >> $file
	{
    echo "    # Fully-qualified external DNS name pointing to the Hypori Admin Console
    # (This setting is not required, but should be populated for reference.)"
    } >> $file
	echo "The external Management FQDN is set to $ma_fqdn"
	read -rp "Is this correct y\n: " mf_an
	if [ "$mf_an" = y ]
	then
		echo "    profile::mgmt::ext_mgmt_fqdn: \"$ma_fqdn"\" >> $file
	else 
		read -rp "What is the external Management FQDN: "
		echo "    profile::mgmt::ext_mgmt_fqdn: \"$ma_fqdn"\" >> $file
	fi
    echo "" >> $file
	{
    echo "    # These settings are required, and must be different from 'ext_mgmt_fqdn' set above.
    # Fully-qualified external DNS name pointing to the user provisioning application"
    } >> $file
	echo "The Hypori User Provisioning FQDN is set to $ma_pro"
	read -rp "Is this correct y\n: " mpo_an
	if [ "$mpo_an" = y ]
	then
		echo "    profile::mgmt::ext_userprov_fqdn: \"$ma_pro"\" >> $file
	else
		read -rp "What is the Hypori User Provisioning FQDN: " ma_auth
		echo "    profile::mgmt::ext_userprov_fqdn: \"$ma_pro"\" >> $file
	fi
	echo "" >> $file
	echo "    # Fully-qualified external DNS name pointing to the client authentication endpoint" >> $file
	echo "The Hypori User Authentication FQDN is set to $ma_auth"
	read -rp "Is this correct y\n: " mau_an
	if [ "$mau_an" = y ]
	then
		echo "    profile::mgmt::ext_auth_fqdn: \"$ma_auth"\" >> $file
	else
		read -rp "What is the Hypori User Authentication FQDN: " ma_auth
		echo "    profile::mgmt::ext_auth_fqdn: \"$ma_auth"\" >> $file
	fi
    echo "" >> $file
    echo "    # Fully-qualified external DNS name pointing to the client notification endpoint" >> $file
	echo "The FQDN for client notification is currently set to $ma_not"
	read -rp "Is this correct y\n: " mno_an
	if [ "$mno_an" = y ]
	then
		echo "    profile::mgmt::ext_notify_fqdn: \"$ma_not"\" >> $file
	else
		read -rp "What is the FQDN for client notification: " ma_not
		echo "    profile::mgmt::ext_notify_fqdn: \"$ma_not"\" >> $file
	fi
    echo "" >> setup.ini
	{
    echo "    # Set only if the external domain for compute nodes is not 'droidcloud.mobi'
        # (This does not apply to any of the FQDNs above, only to compute node names.)"
    } >> $file
	echo "Domain rewrite is set to $ma_rew"
	read -rp "Is this correct y\n: " mr_an
	if [ "$mr_an" = y ]
	then
		echo "    profile::mgmt::rewrite_domain_name   : \"$ma_rew"\" >> $file
	else
		read -rp "What is the external domain name: " ma_rew 
		echo "    profile::mgmt::rewrite_domain_name   : \"$ma_rew"\" >> $file
	fi
	echo "" >> $file
	echo "    # Uncomment if management role needs to be connected to enterprise network also" >> $file
	echo "Management VM connection to the Enterprise Network is currently set to $ma_ent" 
	read -rp "Is this correct y\n: " me_an
	if [ "$me_an" = y ] && [ "$ma_ent" = "true" ]
	then
		echo "Management VMs interface on the Enterprise Network is $mae_int"
		read -rp "Is this correct y\n: " mei_an
		if [ "$mei_an" = y ]
		then
			echo "    profile::mgmt::hostnet::ent_if : \"$mae_int"\" >> $file
		else
			read -rp "What interface on the Management VM will be used on the Enterprise Network: " mae_int
			echo "    profile::mgmt::hostnet::ent_if : \"$mae_int"\" >> $file
		fi
		echo "Management VMs IP on the Enterprise Network is $mae_ip"
		read -rp "Is this correct y\n" meip_an
		if [ "$meip_an" ]
		then
			echo "    profile::mgmt::hostnet::ent_ip : \"$mae_ip"\" >> $file
		else 
			read -rp "What is the ip for the Management VM on the Enterprise Network: " mae_ip
			echo "    profile::mgmt::hostnet::ent_ip : \"$mae_ip"\" >> $file
		fi
	fi
    if [ "$me_an" = n ] && [ "$ma_ent" = "true" ]
    then
		echo "    #profile::mgmt::hostnet::ent_if : \"eth2"\" >> $file
		echo "    #profile::mgmt::hostnet::ent_ip : \"10.40.23.10"\" >> $file
        fi
    if [ "$me_an" = n ] && [ "$ma_ent" = "false" ]
	then
		echo "Management VMs interface on the Enterprise Network is $mae_int"
		read -rp "Is this correct y\n: " mei_an
		if [ "$mei_an" = y ]
		then
			echo "    profile::mgmt::hostnet::ent_if : \"$mae_int"\" >> $file
		else
			read -rp "What interface on the Management VM will be used on the Enterprise Network: " mae_int
			echo "    profile::mgmt::hostnet::ent_if : \"$mae_int"\" >> $file
		fi
		echo "Management VMs IP on the Enterprise Network is $mae_ip"
		read -rp "Is this correct y\n" meip_an
		if [ "$meip_an" ]
		then
			echo "    profile::mgmt::hostnet::ent_ip : \"$mae_ip"\" >> $file
		else 
			read -rp "What is the ip for the Management VM on the Enterprise Network: " mae_ip
			echo "    profile::mgmt::hostnet::ent_ip : \"$mae_ip"\" >> $file
		fi
	fi
    if [ "$me_an" = y ] && [ "$ma_ent" = "false" ]
    then
		echo "    #profile::mgmt::hostnet::ent_if : \"eth2"\" >> $file
		echo "    #profile::mgmt::hostnet::ent_ip : \"10.40.23.10"\" >> $file
	fi
	echo "" >> $file
	echo "    # Uncomment if the management server is behind a TLS proxy" >> $file
	echo "The use of a proxy is set to $ma_prox"
	read -rp "Is this correct y\n: " mprox_an
	if [ "$mprox_an" = y ]
	then
		echo "Proxy setting for subnet or single IP is $mas_an"
		read -rp "Is this correct y\n: " mss_an
		if [ "$mss_an" = y ] && [ "$mas_an" = subnet ] 
		then
			echo "Proxy subnet is currently set to $ma_sub"
			read -rp "Is this correct y\n: " masub_an
			if [ "$masub_an" = y ]
			then
                echo "    profile::mgmt::trusted_proxies:" >> $file				
                echo "        - \"$ma_sub"\" >> $file
			else
				read -rp "What subnet do you want to use for the proxy: " ma_sub
                echo "    profile::mgmt::trusted_proxies:" >> $file				
                echo "        - \"$ma_sub"\" >> $file
			fi
		else
			if [ "$mss_an" = y ] && [ "$mas_an" = single ]
			then
				echo "Proxy IP is set to $ma_sin"
				read -rp "Is this correct y\n: " masin_an
				if [ "$masin_an" = y ]
				then
					echo "    profile::mgmt::trusted_proxies:" >> $file
                    echo "        - \"$ma_sin"\" >> $file
				else
					read -rp "What is the IP of the proxy: " ma_sin
                    echo "    profile::mgmt::trusted_proxies:" >> $file					
                    echo "        - \"$ma_sin"\" >> $file
				fi
			fi
		fi
	fi
    if [ "$mprox_an" = n ]
	then
		echo "Proxy setting for subnet or single IP is $mas_an"
		read -rp "Is this correct y\n: " mss_an
		if [ "$mss_an" = n ] && [ "$mas_an" = single ] 
		then
			echo "Proxy subnet is currently set to $ma_sub"
			read -rp "Is this correct y\n: " masub_an
			if [ "$masub_an" = y ]
			then
				echo "    profile::mgmt::trusted_proxies:" >> $file
                echo "        - \"$ma_sub"\" >> $file
			else
				read -rp "What subnet do you want to use for the proxy: " ma_sub
				echo "    profile::mgmt::trusted_proxies:" >> $file
                echo "        - \"$ma_sub"\" >> $file
			fi
		else
			if [ "$mss_an" = n ] && [ "$mas_an" = subnet ]
			then
				echo "Proxy IP is set to $ma_sin"
				read -rp "Is this correct y\n: " masin_an
				if [ "$masin_an" = y ]
				then
					echo "    profile::mgmt::trusted_proxies:" >> $file
                    echo "        - \"$ma_sin"\" >> $file
				else
					read -rp "What is the IP of the proxy: " ma_sin
					echo "    profile::mgmt::trusted_proxies:" >> $file
                    echo "        - \"$ma_sin"\" >> $file
				fi
			fi
		fi
	fi
	echo "" >> $file
	echo "    # push notifications enable/disable and polling interval" >> $file
	echo "Enable push notifications are currently set to $ma_push"
	read -rp "Is this correct y\n: " mpush_an
	if [ "$mpush_an" = y ]
	then
		echo "    profile::mgmt::pushnotifications_enable: $ma_push" >> $file
	else 
		read -rp "Should push notifications be enabled true\false: " ma_push
		echo "    profile::mgmt::pushnotifications_enable: $ma_push" >> $file
	fi
	echo "Enable silent push notifications is currently set to $ma_silent"
	read -rp "Is this correct y\n: " masil_an
	if [ "$masil_an" = y ]
	then
		echo "    profile::mgmt::silent_pushnotifications: $ma_silent" >> $file
	else
		read -rp "Should silent push notifications be enabled true\false: " ma_silent
		echo "    profile::mgmt::silent_pushnotifications: $ma_silent" >> $file
	fi
	if [ "$ma_push" = "true" ] || [ "$ma_silent" = "true" ]
	then
		echo "Push notification interval is set to $map_time"
		read -rp "Is this correect y\n: " mtime_an
		if [ "$mtime_an" = y ]
		then
			echo "    #profile::mgmt::pollnotifications_interval: $map_time" >> $file
		else
			read -rp "What should the time interval be for push notification in seconds: " map_time
			echo "    #profile::mgmt::pollnotifications_interval: $map_time" >> $file
		fi
	fi
    {	
    echo "    #profile::mgmt::pushnotifications_env: prod
    #profile::mgmt::pushnotifications_gcm_api_key: \"<customer-GCM-project-server-api-key>\"
    #profile::mgmt::pushnotifications_gcm_sender_id: \"<customer-GCM-project-sender-id>\"
    #profile::mgmt::pushnotifications_apn_prodcert_password: \"<customer-CBS-client-APN-prodcert-password>\"
    #profile::mgmt::mgmtconfig::pushnotifications_apn_sandboxcert_password: \"<customer-CBS-client-APN-sandboxcert-password>\"
	## comment out below if you want snmp monitoring disabled
	mgmt::custom_modules :
	        - profile::apps::snmpapp"
    } >> $file
fi
echo
echo "" >> $file
echo "#Storage Node" >> $file
if [ "$sy_vm" = n ] && [ "$com_stor" = "local" ]
then
    {	
    echo "#storage.droidcloud.mobi:
	#  hostinfo:
	#   macaddr   : \"506b8d5e3270\"
	#   build     : true
	#   hostgroup : \"HyporiStorage\"
	#   ipaddress : \"10.40.21.20\"
	
	#  puppet_config_info:
	#   profile::storage::disable_puppet_run  : false
	#   profile::storage::controller_ip       : \"10.40.21.12\"
	#   profile::storage::storage_ip          : \"10.40.21.20\"
	#   profile::storage::storage_host        : \"storage.droidcloud.mobi\"
	#   role::storage::storage_type           : \"nfs\" 
	#   ## Ensure the nfs share is specified when the storage_type is \"nfs\"
	#   role::storage::storage_nfs_share      : \"ntxstor.droidcloud.mobi:/NTFSTOR\"
	#   profile::storage::nfs_mount_options: \"rw,hard,intr,retrans=3,proto=tcp,sec=sys,vers=4\"
	#   profile::storage::hostnet::cust_net_if: \"eth1\"
	#   profile::storage::hostnet::cust_net_ip: \"10.40.25.20\"
	#   profile::storage::hostnet::cust_net_mask: \"255.255.255.0\"
	#   profile::storage::hostnet::cust_net_gwy: \"10.40.25.1\"
	   ## comment out below if you want snmp monitoring disabled
	#   storage::custom_modules :
	#       - profile::apps::snmpapp"
    } >> $file
fi
if [ "$sy_vm" = y ] && [ "$com_stor" = NFS ]
then
	echo "===============Storage Server Configuration==============="
	echo "$sto_domain:" >> $file
	echo "  hostinfo:" >> $file
	read -rp "What is the mac address of the Storage VMs Management Network interface: " st_mac
	read -rp "Should we build the Storage VM true\false: " st_build
	read -rp "What is the Storage VMs hostname: " st_host
	read -rp "What is the Storage VMs ip on the Management Network: " st_mip
	read -rp "Should puppet be disabled from running on the Storage VM true\false: " st_puppet
	read -rp "What interface should be use for the Storage VMs Storage Network: " st_stint
	read -rp "What IP should be use for the Storage VMs Storage Network: " sti_stip
	echo 
	echo "===========Storage Server Configuration Confirmation============"
	echo "The mac address for the Storage VMs on the Management network is set to $st_mac"
	read -rp "Is this correct y\n: " sm_an
	if [ "$sm_an" = y ]
	then
		echo "   macaddr   : \"$st_mac"\" >> $file
	else
		read -rp "What is the mac address of the Storage VMs Management Network interface: " st_mac
		echo "   macaddr   : \"$st_mac"\" >> $file
	fi
	echo "To build the Storage VM is set to $st_build"
	read -rp "Is this correct y\n: " sb_an
	if [ "$sb_an" = y ]
	then
		echo "   build     : $st_build" >> $file
	else
		read -rp "Should we build the Storage VM true\false: " st_build
		echo "   build     : $st_build" >> $file
	fi
	echo "Host name for the Storage VM is set to $st_host"
	read -rp "Is this correct y\n: " sh_an
	if [ "$sh_an" = y ]
	then
		echo "   hostgroup : \"$st_host"\" >> $file
	else
		read -rp "What is the Storage VMs hostname: " st_host
		echo "   hostgroup : \"$st_host"\" >> $file
	fi
	echo "The IP for the Storage VM on the Management Network is $st_mip"
	read -rp "Is this correct y\n: " sm_an
	if [ "$sm_an" = y ]
	then
		echo "   ipaddress : \"$st_mip"\" >> $file
	else
		read -rp "What is the Storage VMs ip on the Management Network: " st_mip
		echo "   ipaddress : \"$st_mip"\" >> $file
	fi
	echo "" >> $file
	echo "  puppet_config_info:" >> $file
	echo "Puppet disable on the Storage VM is set $st_puppet"
	read -rp "Is this correct y\n: " sp_an
	if [ "$sp_an" = y ]
	then
		echo "   profile::storage::disable_puppet_run  : $st_puppet" >> $file
	else
		read -rp "Should puppet be disabled from running on the Storage VM true\false: " st_puppet
		echo "   profile::storage::disable_puppet_run  : $st_puppet" >> $file
	fi
    {
	echo "   profile::storage::controller_ip       : \"""$con_ip""\"
    profile::storage::storage_ip          : \""$st_mip"\"
    profile::storage::storage_host        : \""$sto_domain"\" 
    role::storage::storage_type           : \"nfs\" 
    ## Ensure the nfs share is specified when the storage_type is \"nfs\"
    role::storage::storage_nfs_share      : \""$stor_nfs"\"
    profile::storage::nfs_mount_options: \"rw,hard,intr,retrans=3,proto=tcp,sec=sys,vers=4\""
    } >> $file
	echo "The interface for the Storage VM on the Storage Network is set to $st_stint"
	read -rp "Is this correct y\n: " sint_an
	if [ "$sint_an" = y ]
	then
		echo "   profile::storage::hostnet::cust_net_if: \"$st_stint"\" >> $file
	else 
		read -rp "What interface should be use for the Storage VMs Storage Network: " st_stint
		echo "   profile::storage::hostnet::cust_net_if: \"$st_stint"\" >> $file
	fi
	echo "The IP for the Storage VM on the Storage Network is $sti_stip" 
	read -rp "Is this correct y\n: " sip_an
	if [ "$sip_an" = y ]
	then
		echo "   profile::storage::hostnet::cust_net_ip: \"$sti_stip"\" >> $file
	else
		read -rp "What IP should be use for the Storage VMs Storage Network: " sti_stip
		echo "   profile::storage::hostnet::cust_net_ip: \"$sti_stip"\" >> $file
	fi
    {
	echo "   profile::storage::hostnet::cust_net_mask: \""$stor_netmask"\" 
    profile::storage::hostnet::cust_net_gwy: \""$stor_gate"\"
    ## comment out below if you want snmp monitoring disabled
    storage::custom_modules :
	   - profile::apps::snmpapp"
    } >> $file
fi
echo "" >> setup.ini
{
echo "#common_puppet_info:
#  profile::cpu_alloc_ratio : 24
#  profile::mem_alloc_ratio : 8"
} >> $file
