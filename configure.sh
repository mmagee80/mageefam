#!/bin/sh
#This script gathers information to input into the setup.ini file for Hypori. 

#This is calling out all the variables that will be used in this script and is used and their purpose.
# fips="User Input" Used to set if FIPS mode should be turned on or off.
# new_ca="User Input" Used to determine if a new certificate autority should be genereated for the Hypori servers
# company="User Input" Company name for the CA
# domain="User Input" Company domain for the CA
# country="User Input" Company country for the CA
# state="User Input" Company state for the CA
# location="User Input" Company location for the CA
# display_gateway="User Input" Assigns display gateway for the Hypori servers
# display_netmask="User Input" Assigns display netmask for the Hypori servers
# display_vlan_present="User Input" Determines if there is a vlan tagging present on the compute node
# display_vlan_tag="User Input" Assigns VLAN ID for the display vlan
# ent_gateway="User Input" Assigns enterprise gateway for the Hypori devices
# ent_netmask="User Input" Assigns enterprise gateway for the hypori devices
# ent_vlan_present="User Input" Determines if there is a vlan tagging present on the copmute node
# ent_vlan_tag="User Input" Assigns VLAN ID for enterprise vlan
# ent_dns="User Input" Assigns enterprise DNS ip
# mgmt_gateway="User Input" Assigns management gateway for Hypori servers
# mgmt_netmask="User Input" Assigns management netmask for Hypori servers
# mgmt_dns="User Input" Assigns management DNS server
# mgmt_dns2="User Input" Assigns management Secondary DNS server
# mgmt_ntp_server"User Input" Assigns management NTP server
# mgmt_subnet_range_start="User Input" Assigns mamanagemt DHCP starting IP for PXE booting
# mgmt_subnet_range_end="User Input" Assigns management DHCP ending IP for PXE booting
# foreman_name="User Input" Assigns hostname to provisioning server
# foreman_ip="User Input" Assigns IP to provisioning server
# foreman_interface="User Input" Assigns network interface for provisioning server


#Clearing out possible left over variable values that might have been run previously.
fips=""
new_ca=""
company=""
domain=""
country=""
state=""
location=""
display_gateway=""
display_netmask=""
display_vlan_present=""
display_vlan_tag=""
ent_gateway=""
ent_netmask=""
ent_vlan_present=""
ent_vlan_tag=""
ent_dns=""
mgmt_gateway=""
mgmt_netmask=""
mgmt_dns=""
mgmt_dns2=""
mgmt_ntp_server=""
mgmt_subnet_range_start=""
mgmt_subnet_range_end=""
foreman_name=""
foreman_ip=""
foreman_interface=""

#Remove and create a file that has site settings saved.
rm setup.ini
touch setup.ini

echo "==========FIPS information========="
echo "Do you want to enable FIPS"
read -rp "FIPS Enabled true\false: " fips
echo
echo "================Certificate Autority information============="
echo "A CA is created for Hypori servers to communicate securely to each other. You can choose to create a new CA or use an existing CA."
read -rp "Create a new CA true\false: " new_ca
if [ "$new_ca" = true ]
then 
	read -rp "Company Name: " company
	read -rp "Domain Name: " domain
	read -rp "Country Name: " country
	read -rp "State Name: " state
	read -rp "City Location: " location
fi
echo
echo "============Display Network Settings============"
echo "Display Gateway Information"
read -rp "What is the Gateway IP for the Display Network: " display_gateway
echo "Display Network Netmask Information"
read -rp "What is the Netmask for the Display Network: " display_netmask
echo "Display network vlan. This will be used on the compute nodes for network segmenting"
read -rp "Do you want to use vlan tagging for the Display network on the compute node. true\false: " display_vlan_present
if [ "$display_vlan_present" = true ]
then
	echo "What is the Dispaly vlan id"
	read -rp "Display Vlan ID is: " display_vlan_tag
else
	echo "Display network will be unttagged on compute node"
fi
echo
echo "=========Enterprise Network settings============="
echo "Enterprise Gateway Information. This is the customers network information. This is where the VMIs will get their IPs from"
read -rp "What is the IP for the gateway on the Enterprise Network: " ent_gateway
read -rp "What is the Enterprise Networks Netmask: " ent_netmask
echo "Enterprise network vlan. This will be used on the compute nodes for network segmenting"
read -rp "Do you want to use vlan tagging for the Enterprise network on the compute node. true\false: " ent_vlan_present
if [ "$ent_vlan_present" = true ]
then
	read -rp "What is the Enterprise VLAN ID: " ent_vlan_tag
else 
	echo "Enterprise network will be untagged on the compute node"
fi
read -rp "What is the primary DNS server for the Enterprise Network: " ent_dns
echo
echo "================Management Network settings=================="
echo "Management Gateway Information. This is the network that the Provo server will use to provision out the other VMs"
read -rp "What is the IP for the gateway on the Management Network: " mgmt_gateway
read -rp "What is the Management Networks Netmask: " mgmt_netmask
read -rp "What is the primary DNS server for the Management Network: " mgmt_dns
read -rp "What is the secondary DNS server for the Management Network: " mgmt_dns2
read -rp "What is the primary NTP server for the Management Network: " mgmt_ntp_server
echo "The following IP range is the IPs used to provision Hypori servers through PXE boot"
read -rp "What is the starting IP for the Management DHCP. This is used to boot PXE boot the Hypori Servers: " mgmt_subnet_range_start
read -rp "What is the ending IP for the Management DHCP: " mgmt_subnet_range_end
echo
echo "================Provisioning Server Settings==========="
echo "Time to assign a hostname for provisioning server. This is typically hypprovisioning: "
read -rp "Provision server hostname is: " foreman_name
read -rp "Provisioning server needs to be on the management network. Please assign an IP for the provisioning server: " foreman_ip
read -rp "What interface should the provisioning server use: " foreman_interface
{
echo





}
echo "================================================================================================"
echo "Confirmation of customer settings"
echo "========FIPS Confirmation==================="
echo "FIPS setting set to: $fips"
read -rp "Is this correct y\n: " fip_answer
if [ "$fips" = true ] && [ "$fip_answer" = y ]
then 
	{
    echo "[DEFAULT]
#
# To install hosts in FIPS 140-2 mode, set this flag to true
#
enable_fips_mode: "$fips"" 
	}>> setup.ini
else
	if [ "$fip_answer" = n ]
	then
	echo "Should FIPS be enabled"
	read -rp "true\false: " fips
	{
	echo '[DEFAULT]
#
# To install hosts in FIPS 140-2 mode, set this flag to true
#
enable_fips_mode: "$fips"' 
	}>> setup.ini
	fi
fi
echo "" >> setup.ini
echo "==========Confirmation of CA creation================"
echo "New CA creating set to: $new_ca"
read -rp "Is this correct y\n: " answer_ca
if [ "$answer_ca" = y ] && [ "$new_ca" = false ] 
then
	{
    echo "[Organization]
# If needed, you can place your organization's CA (crt & key) in /root/hypori/certs/ca_certs.
# This will result in all server & client certs being issued using your organizations CA.
# If you want a brand new CA generated by Hypori for this install, set newca to true
newca: "$new_ca"
	
# If you change any of these values please set the "newca" flag above to "true"
company_name: Hypori
domain: droidcloud.mobi
country: US
state: Tx
location: Austin"
	} >> setup.ini
    else 
	read -rp "Should a new ca be built true\false: " new_ca
	if [ "$new_ca" = true ]
		then
				read -rp "Company Name: " company
        		read -rp "Domain Name: " domain
        		read -rp "Country Name: " country
        		read -rp "State Name: " state
        		read -rp "Location: " location
				
			{
            echo "[Organization]
# If needed, you can place your organization's CA (crt & key) in /root/hypori/certs/ca_certs.
# This will result in all server & client certs being issued using your organizations CA.
# If you want a brand new CA generated by Hypori for this install, set newca to true
newca: "$new_ca" 
			
# If you change any of these values please set the "newca" flag above to \"true\"
company_name: "$company" 
domain: "$domain" 
country: "$country" 
state: "$state" 
location: "$location""
            } >> setup.ini
	fi
fi
echo "" >> setup.ini
echo
echo "===========Display Network Confirmation==========="
{
echo "# Display network values are used ONLY if you want to split display from the Enteprise network
# If you are running with Display and Enterprise network as the same, the values for gateway and netmask
# in Display_network section need to match the corresponding ones in enterprise network.
[display_network]"
} >> setup.ini
echo "Display network's gateway is set to $display_gateway"
read -rp "Is this correect y\n: " dg_answer
if [ "$dg_answer" = y ]
then
	echo display_gateway: "$display_gateway" >> setup.ini
else 
	read -rp " Dispaly Gateway IP: " display_gateway
	echo display_netmask: "$display_gateway" >> setup.ini
fi
echo "Display network's netmask is set to $display_netmask"
read -rp "Is this correect y\n: " dn_answer
if [ "$dn_answer" = y ]
then
	echo display_netmask: "$display_netmask" >> setup.ini
else 
	read -rp " Dispaly networks netmask is: " display_gateway
	echo display_netmask: "$display_netmask" >> setup.ini
fi
echo "" >> setup.ini
echo "# vlan attributes" >> setup.ini
echo "Display vlan tagged on compute node is set to $display_vlan_present"
read -rp "Is this correct y\n: " dv_answer
if [ "$dv_answer" = y ] && [ "$display_vlan_present" = "true" ]
then 
	echo display_vlan_present: "$display_vlan_present" >> setup.ini
	echo "Display vlan tag = $display_vlan_tag"
	read -rp "Is this correct y\n: " dv_tag
	if [ "$dv_tag" = y ] 
	then
		echo display_vlan_tag: "$display_vlan_tag" >> setup.ini
	else
		read -rp "What is the vlan ID: " display_vlan_tag
		echo display_vlan_tag: "$display_vlan_tag" >> setup.ini
	fi
fi	
if [ "$dv_answer" = y ] && [ "$display_vlan_present" = "false" ]
then
	echo Display Network traffic will not be tagged
	display_vlan_present=false
	echo display_vlan_present: "$display_vlan_present" >> setup.ini
	display_vlan_tag=0
	echo display_vlan_tag: "$display_vlan_tag" >> setup.ini
fi
if [ "$dv_answer" = n ] && [ "$display_vlan_present" = "true" ]
then
	echo Display Network traffic will not be tagged
	display_vlan_present=false
	echo display_vlan_present: "$display_vlan_present" >> setup.ini
	display_vlan_tag=0
	echo display_vlan_tag: "$display_vlan_tag" >> setup.ini
fi
if [ "$dv_answer" = n ] && [ "$display_vlan_present" = "false" ]
then 
	display_vlan_present="true"
	echo display_vlan_present: "$display_vlan_present" >> setup.ini
	echo "What is the Dispaly vlan id"
	read -rp "Display Vlan ID is: " display_vlan_tag
	echo display_vlan_tag: "$display_vlan_tag" >> setup.ini
fi	
echo
echo "" >> setup.ini
{
echo "# Enterprise_network : this is the network to which virtual devices are connected
# 2 network types are supported, flat, vlan.
# Please refer to the docs to decide when to use which type.
[enterprise_network]" 
}>> setup.ini
echo
echo "===========Enterprise Network Confirmation=============="
echo "Enterprise network's gateway is $ent_gateway"
read -rp "Is this correct y\n: " eg_answer
if [ "$eg_answer" = yes ]
then
        echo ent_gateway: "$ent_gateway" >> setup.ini
else 
	read -rp "Enterprise Gateway IP: " ent_gateway
	echo ent_gateway: "$ent_gateway" >> setup.ini
fi
echo "Enterprise network netmask is $ent_netmask"
read -rp "Is this correct y\n: " en_answer
if [ "$en_answer" = y ]
then
        echo ent_netmask: "$ent_netmask" >> setup.ini
else
	read -rp "Enterprise Netmask is: " ent_netmask
	echo ent_netmask: "$ent_netmask" >> setup.ini
fi
echo "" >> setup.ini
echo "# vlan attributes" >> setup.ini
echo "Enterprise vlan tagged on compute node is set to $ent_vlan_present"
read -rp "Is this correct y\n: " ev_answer
if [ "$ev_answer" = y ] && [ "$ent_vlan_present" = "true" ]
then 
	echo ent_vlan_present: "$ent_vlan_present" >> setup.ini
	echo "Enterprise vlan tag = $ent_vlan_tag"
	read -rp "Is this correct y\n: " ev_tag
	if [ "$ev_tag" = y ]
	then
		echo ent_vlan_tag: "$ent_vlan_tag" >> setup.ini
	else
		read -rp "What is the vlan ID: " ent_vlan_tag
		echo ent_vlan_tag: "$ent_vlan_tag" >> setup.ini
	fi
fi
if [ "$ev_answer" = y ] && [ "$ent_vlan_present" = "false" ]
then
	echo Display Network traffic will not be tagged
	ent_vlan_present=false
	echo ent_vlan_present: "$ent_vlan_present" >> setup.ini
	ent_vlan_tag=0
	echo ent_vlan_tag: "$ent_vlan_tag" >> setup.ini
fi
if [ "$ev_answer" = n ] && [ "$ent_vlan_present" = "true" ]
then
	echo Enterprise Network traffic will not be tagged
	ent_vlan_present=""
	echo ent_vlan_present: "$ent_vlan_present" >> setup.ini
	ent_vlan_tag=""
	echo ent_vlan_tag: "$ent_vlan_tag" >> setup.ini
fi
if [ "$ev_answer" = n ] && [ "$ent_vlan_present" = "false" ]
then 
	ent_vlan_present="true"
	echo ent_vlan_present: "$ent_vlan_present" >> setup.ini
	read -rp "What is the Enterprise VLAN ID: " ent_vlan_tag
	echo ent_vlan_tag: "$ent_vlan_tag" >> setup.ini
fi
echo "" >> setup.ini
{
echo "# DNS used by the virtual devices. By default set to point to Vyatta
# For local VM installs change this value as appropriate and should be reachable by virtual devices"
}>> setup.ini

echo "Enterprise Network DNS server IP is set to $ent_dns"
read -rp "Is this correct y\n: " ed_answer
if [ "$ed_answer" = y ]
then
	echo ent_dns: "$ent_dns" >> setup.ini
else 
	read -rp "What is the primary Enterprise DNS IP: " ent_dns
	echo ent_dns: "$ent_dns" >> setup.ini
fi
echo
echo "================Management Network Confirmation============"
echo "" >> setup.ini
{
echo "# management network values
[management_network]"
}>> setup.ini
echo "Management network's gateway is $mgmt_gateway"
read -rp "Is this correct y\n: " mg_answer
if [ "$mg_answer" = y ]
then
	echo mgmt_gateway: "$mgmt_gateway" >> setup.ini
else 
	read -rp " Management Gateway IP: " mgmt_gateway
	echo mgmt_gateway: "$mgmt_gateway" >> setup.ini
fi
echo "Management network's netmask is $mgmt_netmask"
read -rp "Is this correct y\n: " mn_answer
if [ "$mn_answer" = y ]
then
	echo mgmt_netmask: "$mgmt_netmask" >> setup.ini
else
	read -rp "Management netmask: " mgmt_netmask
	echo mgmt_netmask: "$mgmt_netmask" >> setup.ini
fi
echo "" >> setup.ini
{
echo "# DNS and NTP entries point to Vyatta router with DNS forwarding turned on. For local VM
# installs change the mgmt_dns and mgmt_ntp_server values
# should be reachable from within the management n/w."
}>> setup.ini
echo "Management Network primary DNS is $mgmt_dns"
read -rp "Is this correct y\n: " md_answer
if [ "$md_answer" = y ]
then 
	echo mgmt_dns: "$mgmt_dns" >> setup.ini
else 
	read -rp "Management Primary DNS IP: " mgmt_dns
	echo mgmt_dns: "$mgmt_dns" >> setup.ini
fi
echo "Management Network secondary DNS is $mgmt_dns2"
read -rp "Is this correct y\n: " md2_answer
if [ "$md2_answer" = y ]
then
	echo mgmt_dns2: "$mgmt_dns2" >> setup.ini
else
	read -rp "Management Network secondary DNS IP: " mgmt_dns2
	echo mgmt_dns2: "$mgmt_dns2" >> setup.ini
fi
echo "Management Network NTP is $mgmt_ntp_server"
read -rp "Is this correct y\n: " mp_answer
if [ "$mp_answer" = y ]
then
	echo mgmt_ntp_server: "$mgmt_ntp_server" >> setup.ini
else
	read -rp "Management Network NTP is: " mgmt_ntp_server
	echo mgmt_ntp_server: "$mgmt_ntp_server" >> setup.ini
fi
echo "" >> setup.ini
{
echo "# The range of IPs that can used by the Foreman DHCP server to discover facts of new hosts  by PXE booting them
# hosts which are provisioned (controller, compute, management...) should be assigned static IPs outside this range"
} >> setup.ini
echo "Management Network DHCP starting range is $mgmt_subnet_range_start"
read -rp "Is this correct y\n: " ms_answer
if [ "$ms_answer" = y ]
then
	echo mgmt_subnet_range_start: "$mgmt_subnet_range_start" >> setup.ini
else
	read -rp "Management Network DHCP starting range is: " mgmt_subnet_range_start
	echo mgmt_subnet_range_start: "$mgmt_subnet_range_start" >> setup.ini
fi
echo "Management Network DHCP ending range is $mgmt_subnet_range_end"
read -rp "Is this correct y\n: " me_answer
if [ "$me_answer" = y ]
then
	echo mgmt_subnet_range_end: "$mgmt_subnet_range_end" >> setup.ini
else
	read -rp "Management Network DHCP ending range is: " mgmt_subnet_range_end
	echo mgmt_subnet_range_end: "$mgmt_subnet_range_end" >> setup.ini
fi
echo
echo "============Provisioning Server Settings========"
echo "" >>setup.ini
echo "[provisioning_server]" >> setup.ini
echo "Provisioning Server name is $foreman_name"
read -rp "Is this correct y\n: " fn_answer
if [ "$fn_answer" = y ]
then
	echo foreman_name: "$foreman_name" >> setup.ini
else 
	read -rp "Provisioning server hostname: " foreman_name
	echo foreman_name: "$foreman_name" >> setup.ini
fi
echo "" >> setup.ini
{
echo "#foreman_ip is a fixed ip on the management network configured above. It has to be an IP outside the range specified above
#.1 and .2 are usually default routers for the subnet" 
} >> setup.ini
echo "Provisioning Server IP is $foreman_ip"
read -rp "Is this correct y\n: " fi_answer
if [ "$fi_answer" = y ]
then
	echo foreman_ip: "$foreman_ip" >> setup.ini
else 
	read -rp "What is the IP for the Provisioning Server: " foreman_ip
	echo foreman_ip: "$foreman_ip" >> setup.ini
fi
echo "" >> setup.ini
echo "#foreman_interface is the interface to which management/PXE network is physically connected" >> setup.ini
echo "Provisioning server interface is $foreman_interface"
read -rp "Is this correct y\n: " fe_answer
if [ "$fe_answer" = y ]
then
	echo foreman_interface: "$foreman_interface" >> setup.ini
else
	read -rp "What is the Provisioning Server interface: " foreman_interface
	echo foreman_interface: "$foreman_interface" >> setup.ini
fi

echo "===============Verification complete================"
echo "" >> setup.ini
{
echo "# ADMIN stuff (DON'T CHANGE)
[openstack]
admin_tenant_name: admin
admin_user_name: admin
tenant_name: hypori
tenant_user_name: hypori "
} >> setup.ini

