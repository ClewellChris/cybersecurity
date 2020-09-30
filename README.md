Automated ELK Stack Deployment
The files in this repository were used to configure the network depicted below.

/Images/RedTeam_Elk Diagram.png

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the ELK file may be used to install only certain pieces of it, such as Filebeat.

TODO: Enter the playbook file.
This document contains the following details:

Description of the Topology
Access Policies
ELK Configuration
Beats in Use
Machines Being Monitored
How to Use the Ansible Build
Description of the Topology
The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly redundant, in addition to restricting unauthorized access to the network.

Load balancers protect from DDoS attacks by off loading attack traffic to a public server. The advantage of having a jumpbox is having a secured barrier to the virtual network. It allows admins to keep their systems secure from atackers attempting to steal credentials
Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the logs and system traffic.

What does Filebeat watch for? Log Files and locations specified by the user and indexes them
What does Metricbeat record? Periodically records metrics from the system and services running on the server
The configuration details of each machine may be found below. Note: Use the Markdown Table Generator to add/remove values from the table.

Name	Function	IP Address	Operating System
Jump Box	Gateway	10.0.0.1	Linux
Web-1	Server	10.0.0.7	Linux
Web-2	Server	10.0.0.8	Linux
Web-3	Server	10.0.0.9	Linux
Elk	Server	10.1.0.4	Linux
LB	Load Bal	52.191.136.128	N/A
Access Policies
The machines on the internal network are not exposed to the public Internet.

Only the JumpBox machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:

75.166.168.234
76.25.65.45
192.168.0.7
Machines within the network can only be accessed by JumpBox and ELK server.

75.166.168.234 has SSH access to Jumpbox
A summary of the access policies in place can be found in the table below.

Name	Publicly Accessible	Allowed IP Addresses
Jump Box	Yes	75.166.168.234
ELK	Yes	10.0.0.4/32
LB	Yes	75.166.168.234
Web Servers	No	52.191.136.128 (LB)
Elk Configuration
Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...

Using ansible to automate configuration allows for limitless servers to be configured without having to access every individual server
The playbook implements the following tasks:

Downloads and configures ELK/Kibana on the designated ELK server using Docker
Downloads and configures FileBeat and MetricBeat on the DVWA/Webservers
Downloads and configures DVWA on the Webservers
The following screenshot displays the result of running docker ps after successfully configuring the ELK instance.

Images/ELK Snip.jpg

Target Machines & Beats
This ELK server is configured to monitor the following machines:

10.0.0.7
10.0.0.8
10.0.0.9
We have installed the following Beats on these machines:

MetricBeat and FileBeat
These Beats allow us to collect the following information from each machine:

FileBeat allows us to see any SSH connections, changes to the system log, and any sudo commands used on the Web servers
MetricBeat shows us the memory usage and cpu usage so we can see if there is an increase in traffic to the Web servers
Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned:

SSH into the control node and follow the steps below:

Copy the elk playbook file to the ansible container.
Update the /ansible/host file to include the IP's of the servers you want to make your installs on
Run the playbook, and navigate to http://elkserverip:5601/app/kibana navigate to Add Metrics > Docker Metrics and Add Log Data > System Logs to check that the installation worked as expected. There will be a button at the bottom of each page to "Check Data" this will tell you if Kibana is receving data from your servers
TODO: Answer the following questions to fill in the blanks:

The playbook file is install-elk-metricbeat-filebeat.yml, needs to be copied to /etc/ansible/roles
You will want to update the /etc/ansible/host file to include all the servers you want to configure. Using your servers private IP to dicate which servers will get ELK and which will get FileBeat and MetricBeat
When you want to check your ELK sever information you will navigate to http://elkserverpublicip:5601/app/kibana
Commands Overview:

download elk playbook, elk-config, metric-config, filebeat-config,
once downloaded use $ cp install-elk-filebeat-metricbeat.yml /etc/ansible/roles
$ cp metric-config filebeat-config /etc/ansible/files
