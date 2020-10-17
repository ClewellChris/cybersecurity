## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![Red Team Vnet](/Diagrams/RedTeam_Elk.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the ELK file may be used to install only certain pieces of it, such as Filebeat.

  - [Elk YML](/Ansible/Elk_YML.yml)
  - [MetricBeat YML](/Ansible/MetricBeat_YML.yml)
  - [FileBeat YML](/Ansible/FileBeat_YML.yml)
  - [Docker YML](/Ansible/Docker_YML.yml)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly redundant, in addition to restricting unauthorized access to the network.
- Load balancers protect from DDoS attacks by off loading attack traffic to a public server. The advantage of having a jumpbox is having a secured barrier to the virtual network.  It allows admins to keep their systems secure from atackers attempting to steal credentials 

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the logs and system traffic.
- What does Filebeat watch for? Log Files and locations specified by the user and indexes them 
- What does Metricbeat record? Periodically records metrics from the system and services running on the server

The configuration details of each machine may be found below.
_Note: Use the [Markdown Table Generator](http://www.tablesgenerator.com/markdown_tables) to add/remove values from the table_.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 10.0.0.1   | Linux            |
| Web-1    |  Server  | 10.0.0.7   | Linux            |
| Web-2    |  Server  | 10.0.0.8   | Linux            |
| Web-3    |  Server  | 10.0.0.9   | Linux            |
| Elk      |  Server  | 10.1.0.4   | Linux            | 
| LB       | Load Bal | 52.191.136.128  |     N/A     |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the JumpBox machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- 75.166.168.234
- 76.25.65.45
- 192.168.0.7

Machines within the network can only be accessed by JumpBox and ELK server.
- 75.166.168.234 has SSH access to Jumpbox

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | Yes                 | 75.166.168.234       |
| ELK      | Yes                 | 10.0.0.4/32          |
| LB       | Yes                 | 75.166.168.234       |
| Web Servers| No                | 52.191.136.128 (LB)  |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
- Using ansible to automate configuration allows for limitless servers to be configured without having to access every individual server

The playbook implements the following tasks:
- Downloads and configures ELK/Kibana on the designated ELK server using Docker 
- Downloads and configures FileBeat and MetricBeat on the DVWA/Webservers
- Downloads and configures DVWA on the Webservers 

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![Elk Screenshot](/Diagrams/ELK.jpg)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- 10.0.0.7
- 10.0.0.8
- 10.0.0.9

We have installed the following Beats on these machines:
- MetricBeat and FileBeat 

These Beats allow us to collect the following information from each machine:
- FileBeat allows us to see any SSH connections, changes to the system log, and any sudo commands used on the Web servers 
- MetricBeat shows us the memory usage and cpu usage so we can see if there is an increase in traffic to the Web servers 

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the elk playbook file to the ansible container.
- Update the /ansible/host file to include the IP's of the servers you want to make your installs on 
- Run the playbook, and navigate to http://elkserverip:5601/app/kibana navigate to Add Metrics > Docker Metrics and Add Log Data > System Logs to check that the installation worked as expected.  There will be a button at the bottom of each page to "Check Data" this will tell you if Kibana is receving data from your servers

- The playbook files are Elk_YML.yml, Docker_YML.yml, and MetricBeat_YML.yml they need to be copied to /etc/ansible/roles
- You will want to update the /etc/ansible/host file to include all the servers you want to configure.  Using your servers private IP to dictate which servers will get ELK and which will get FileBeat and MetricBeat
- When you want to check your ELK sever information you will navigate to http://"elkserverpublicip":5601/app/kibana 

Commands Overview: 
Below are the in-depth commands for running and setting up the above ELK, MetricBeat, and DVWA playbooks.  This walkthrough is assuming you have a network set-up and have designated which servers you want to monitor and which servers you want to do the monitoring.  The entire environment above was built with a Jumpbox being the only access point for Admin. 


1. Setting up DVWA Container
  - To begin I set up 3 individual Webservers to run DVWA behind a Load Balancer to maintain redundancy. If you would like to set up servers to run a DVWA Container then follow along with the instructions below, if not then go to 2. Setting up ELK and MetricBeat and FileBeat. 
  - Its best practice to setup up a secure system from the start.  I began with setting up a Jumpbox on Azure and used an SSH public key as the authentication type using a key I generated using `ssh-keygen`. 
  - Go in to your Azure environment and go to your Jumpbox and go to "Reset Password" to add your ssh-key if you haven't already.  Your machine must be running to make any changes. 
  - Once this is done you will want to make a change to your Security Group the Jumpbox is assgined to allow an SSH connection from your Host machine. 
  - Now that we have that set up we can move on to adding the DVWA Container to the Web Servers. This starts with adding the `Docker_YML.yml` file to the /etc/ansible/roles. 
  - Before you can run the playbook you'll want to update your /etc/ansible/host file to reflect the private ip's of the servers you want to add the DVWA Container to. In this VM they were named `webservers` if yours differ make that change to the `hosts:` section in the `Docker_YML.yml` file. 
  - When adding the ip's in the /etc/hosts you will want to add `ansible_python_interpreter=/usr/bin/python3` at the end of the ip to force ansible to use python 3 on each machine we configure
  - Next we will want to make edits to the `ansible.cfg` file.  When in the file you will want to edit the `remote_user` option to reflect the admin username that is used on the servers you want to add the DVWA container to. 
  - Now we want to `ping` the servers to make sure we are getting a connection. Run `ansible -m ping "server name"`.  If it was successful it will show the ip's of the server| SUCCESS => .  If you don't see the success message you'll want to check your `/etc/ansible/hosts` and `ansible.cfg` files to make sure the Admin usernames and ip's are correct 
  - Once we get success `pinging` our servers then we can run our `Docker_YML.yml` playbook.  Run `ansible-playbook Docker_YML.yml` from inside the folder that the file is in.
  - The playbook will run through each server and make the updates. You should now be able to navigate to your DVWA set up with `http://[load-balancer-ip]/setup.php. 
  - From here you can set up your DVWA server as you see fit. 



2. Setting up ELK and FileBeat
  - If you didn't go through the above DVWA set up we will need to go through some setup before we can run our playbooks. 
  - Before we can run our playbooks we will need to designate which server(s) will host the ELK container and which will host the MetricBeat and FileBeat containers. Those changes are made in the `/etc/ansible/hosts` file and the `ansible.cfg` file. In the hosts file you will want to designate which ip's are which, for example: 
            # This is the default ansible 'hosts' file. 
            #
            # It should live in /etc/ansible/hosts
            # 
            #  - Comments being with the '#' character
            #  - Blank lines are ignored 
            #  - Groups of hosts are delimited by [header] elements
            #  - You can enter hostnames or ip addresses 
            #  - A hostname/IP can be a member of multiple groups
            # You need only a [webservers] and [elk] group 
            #
            # List the IP Addresses of your webservers
            # You should have at least 2 IP addresses 
            [webservers] 
            10.0.0.8 ansible_python_interpreter=/usr/bin/python3
            10.0.0.9 ansible_python_interperter=/usr/bin/python3
            10.0.0.10 ansible_python_interperter=/usr/bin/python3
            # 
            # List IP address(s) of your ELK sever(s)
            # There should only be one for this example but it is scalable
            [elk]
            10.0.1.4 ansible_python_interperter=/usr/bin/python3
  - In the `ansible.cfg` file you will want to update the `remote_user` option to reflect the Admin user of your servers 
  - Now that we have made our updates we are ready to run our playbook. Run `ansible-playbook Elk_YML.yml`. This will set up your ELK server with the ELK container as well as make changes to your memory usage which is neccesary to run Kibana. 
  - Once the program completes, SSH into your ELK server and confirm ELK is running by running `docker ps` and you should see: 
![Elk Screenshot](/Diagrams/ELK.jpg)
  - If you don't see the above image you will want to run `sudo docker start elk` to start the container
  - Once we confirm the container is running we will want to make sure we can access our server. Open your web brower and navigate to http://[your.ELK-VM.External.IP]:5601/app/kibana. You should see the Kibana homepage
  - If you are not able to access the homepage we will want to be sure we are allowing traffic from your work station IP over port 5601
  - Once we are able to access the Kibana homepage we can move to setting up FileBeat and MetricBeat on our `webservers` 
  - Now on to the FileBeat configuration, using the below configuration file you will need to makes changes to lines #1106 and #1806.  You will need to change the IP's to reflect the IP of your ELK server.  You should also update the username and password for this set up I left it as this was a lab set up.
  - [Filebeat Configuration YML](/Ansible/FileBeat-Configuration_YML.yml)
  - This is also a good time to mention that you will want to remember the path that you saved your updated configuration file to as this needs to be reflected in the playbook for it to run correctly 
  - Once you have made your updates to the FileBeat configuration file and updated the path in the playbook we can run `ansible-playbook FileBeat_YML.yml` 
  - Once we see success on our servers we will navigate back to our ELK server GUI and go to `Add Log Data > System Logs > Click DEB tab ` scroll to the bottom and click the `Verify Incoming Data` button.  
  - If we are not seeing any data coming in we know we need to check our configuration file to make sure we are sending data to the correct IP address

3. Setting up and running MetricBeat
  - Like FileBeat, MetricBeat needs to be configured before it can run properly on your servers. 
  - We will be using two configuration files to make sure we are receiving data. 
  - [MetricBeat Configuration YML](/Ansible/MetricBeat_Configuration_YML.yml)
  - [MetricBeat Docker Configuration YML](Ansible/MetricBeat-Docker-Configuration.yml)
  - Same as above you will need to update the ELK server IP in the MetricBeat configuration file. The second file is to set up the Docker module to send data.  If you do some digging you will see that there are numerous modules you can set up to send data. Make note of the path of each configuration file and update the MetricBeat_YML.yml file to reflect those paths  
  - This set up is designed to take advantage of the `modules.d` directory which allows us to enable and disable different modules on our servers.  If you wish to add more modules to monitor you will need to find each individual condfiguration file and make those updates to your playbook. 
  - Now we will run `ansible-playbook MetricBeat_YML.yml` 
  - Once we see success we will navigate back to our ELK server GUI and go to `Add Metric Data > Docker Metrics > Click the DEB tab` and scroll to the bottom and click the `Verify Incoming Data` button. 
  
4. All done! 
  - We have come to the end of setting up an ELK server as well as setting up FileBeat and MetricBeat on servers we want to recieve data from.  However this is not the end of what ELK can do.  Having the above info it is encouraged to continue to dig into ELK and Kibana as your needs see fit. 
  
