#create_user.sls

{% set user_data = salt['pillar.get']('users:kartaca', {}) %}
 create_user:
	user_present:
		-name: kartaca
		-uid: 2024
		-gid: 2024
		-home: /home/krt
		-shell: /bin/bash
		
		
#kartaca_sudo.sls

{% if grains['os_family'] == 'Debian' %}
	kartaca_sudo:
		file.append:
			-name: /etc/sudoers
			-text: 'kartaca ALL=(ALL) NOPASSWD: /usr/bin/apt
{% elif grains['os_family'] == 'RedHat' %}
	kartaca_sudo:
		file.append:
			-name: /etc/sudoers
			-text: 'kartaca ALL=(ALL) NOPASSWD: /usr/bin/yum


{%endif%}
#set_timezone.sls

set_timezone:
	timezone_system:
		-name: Europe/Istanbul

#enable_ip_forwarding.sls	


enable_ip_forwarding:
		sysctl_present:
			- name: net.ipv4.ip_forward
			- value: 1
			- config: /etc/sysctl.conf
			- apply: True
			
			
			
#install_packages_and_configure_hosts.sls
# Gerekli paketlerin kurulumu
install_required_packages:
	pkg.installed:
		- names:
			-htop
			-tcptraceroute
			-ping
			-dig
			-iostat
			-mtr
			
			
			
			
#Hashicorp dosyası

add_hashicorp_repo:
	pkgrepo.managed:
		-name:hashicorp
		- file: /etc/apt/sources.list.d/hashicorp.list
		- humanname: HashiCorp Official Repository
		- key_url: https://apt.releases.hashicorp.com/gpg
		
#Terraform paketi

install_terraform:
	pkg.installed:
		-name: terraform
		-version: 1.6.4
		
#etc/hosts dosyasına IP bloğundaki her bir IP adresi için kayıtlı olmayan host eklenmesi

configure_hosts_file:
	file.append:
		- name: etc/hosts
		- source: salt://hosts/hosts.txt
		- user: root
		- group: root
		- mode: 644
		- template: jinja
		- require:
			-pkg: install_required_packages
			