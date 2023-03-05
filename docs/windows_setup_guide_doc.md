CLICKX.IO 

Windows Setup Guide:

This document will help the user setup the CLICKX ruby on rails web application for the first time on a windows machine.
# Overview:
The following document will go through the following broad steps to complete the setup:

- We will enable Windows subsystem for Linux on the windows machine.
  Please go through the following URL for more information on [WSL](https://docs.microsoft.com/en-us/windows/wsl). 
- Once the windows subsystem linux (Ubuntu in our case) is installed, we will perform the following operations:
  - Pull the code from the git repository and create a new local branch to track changes.
  - Install and dependencies for backend using bundler and frontend using yarn
  - Setup a local copy of the Postgres DB on the machine and make necessary changes to the local copy of the DB inside the server running on the local machine.

# WSL Pre-requisites:
As mentioned in the above link, you must be running 
Windows 10 version 2004 and higher (Build 19041 and higher) or Windows 11.
Our recommendation is to use a machine that has a Windows 11 OS running. 
# Minimum System Requirements for Windows Machine:
The published [system requirements for Windows 11](https://www.microsoft.com/en-us/windows/windows-11-specifications#primaryR2) are as follows:

- Processor: 1GHz or faster with two or more cores on a [compatible 64-bit processor](https://aka.ms/CPUlist) or system on a chip (SoC)
- RAM: at least 4GB
- Storage: at least 64GB of available storage
- Security: TPM version 2.0, UEFI firmware, Secure Boot capable
- Graphics card: Compatible with DirectX 12 or later, with a WDDM 2.0 driver
- Display: High definition (720p) display, 9" or greater monitor, 8-bits per color channel
# Recommended System Requirements for Windows Machine:
We recommend that the machine should have the following specifications over and above the minimum specs to support additional software requirements that are required to complete the installation of the webapp (DB/Cache etc):

- Processor: 2GHz or faster with four/eight cores on a [latest 64-bit processor](https://aka.ms/CPUlist) 
  preferred Intel/AMD. 
- RAM: 16GB
- Storage: 512GB of available storage
# WSL Interface in command prompt:
To start WSL interface, open a new command prompt and type wsl and press enter to confirm that WSL is working. This should take you to the Linux shell.

Example:

The green blue colored line represents the Ubuntu Linux shell. 

Or use the following command
```sh
wsl --help
```
# WSL OS Installation Steps:
Default installation steps for WSL are available here: [wsl-install](https://docs.microsoft.com/en-us/windows/wsl/install)
We recommend installation of Ubuntu linux as the subsystem. 
```sh
wsl --install -d ubuntu
```
Source: 
[https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-10#1-overview](https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-10%231-overview)
## Advantages:
- We are able to run and deploy all dependencies for a ruby on rails project on a Linux subsystem.
- We can use an IDE such as RubyMine or Visual Studio Code to make changes to the code. 
- This allows us to remove the dependency of a Mac machine and resolve any issues related to the new Apple Silicon. 
- Also, rest of the OS remains the same so the user can work on the remaining windows without any problem. 
# Ruby installation Steps:
We will be required to install ruby in the ubuntu machine before proceeding with the next steps.
As a ruby version manager, my recommendation is to use rbenv.

Steps:
```sh
sudo apt update
sudo apt install git curl autoconf bison build-essential \    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \    libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
```
To start using rbenv, you need to add $HOME/.rbenv/bin to your [PATH](https://linuxize.com/post/how-to-add-directory-to-path-in-linux/).

If you are using Bash:
```sh
- echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrcecho 'eval "$(rbenv init -)"' >> ~/.bashrcsource ~/.bashrc
```
Restart the terminal and then perform the following command to check if rbenv has been installed:
```sh
rbenv -v
```
Next, to install ruby 2.6.9, please use the following steps:
```sh
rbenv install 2.6.9
rbenv global 2.6.9
```
Source: <https://linuxize.com/post/how-to-install-ruby-on-ubuntu-20-04/> 

Note:- If the ruby version 2.6.9 is not available or deprecated on rbenv then use rvm to install ruby 2.6.9

Source: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rvm-on-ubuntu-20-04
# Rails app Installation Steps:
Please follow the following steps to install the web application once the WSL installation completes.

To launch the Linux command prompt, simple open any windows command prompt and type wsl and press enter. The windows command prompt will shift to the Linux one.
#### *Ensure that you have access to the github repository:*
This is a precheck before doing a git pull for the code repository.
#### *Downloading the repository*
```sh
git clone https://github.com/1ims/clickx
cd clickx
```

It is recommended that you create a new local branch from the “production” branch and track local changes separately.

#### *Before performing bundle install*
Please delete all contents of the Gemfile.lock file. 
This will help us avoid unnecessary issues with some dependencies while the local installation takes place using bunle operation. This operation my take some time to accomplish 
#### *Install all dependencies*
```sh
bin/setup
```

This command will do the following operations: It will perform:

- Install specific bundler required
- Perform bundle install
- Resolve all dependencies required for the front-end using yarn
- Prepare the database by performing creation, migration and seed
- Remove old log and temp files
- Restart the application server

## Installation of capybara-webkit gem and qt requirement:
#### *Note: The command bundle install may fail due to an installation error related to capybara-webkit gem.*
Please execute the following commands to solve that issue
```sh
sudo apt-get update
sudo apt-get install g++ qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
sudo apt-get install qt-sdk
```
After this, the bundle install completed successfully and installed the capybara-webkit gem

Source:[ https://prathamesh.tech/2019/06/26/installing-capybara-webkit-gem-on-ubuntu-16-04/](%20https://prathamesh.tech/2019/06/26/installing-capybara-webkit-gem-on-ubuntu-16-04/)
#### *Install local DB using Postgres*
Commands:
```sh
sudo apt update
sudo apt install postgresql postgresql-contrib
```
Source: <https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart>
#### *Connect to postgres server using Pgadmin4 application:*
Steps:

- Launch Ubuntu in Windows.
- Start postgres in Ubuntu terminal: sudo service postgresql start
- Download the latest [pgAdmin](https://www.pgadmin.org/download/pgadmin-4-windows/) and install in Windows.
- Launch pgAdmin, a new tab in browser opens; click on *Add New Server* link.
- In the popup *Create - Server* window in the browser:
- *General* tab: I set *Name* to *localhost*
- *Connection* tab: I set *Host name/address* to *localhost*, set *Password* to *postgres*, which is the default, click on Save password?
- I save the setting, leaving the rest of the fields as is
- That's it, I can see the DB created in Postgres immediately.

Source: <https://stackoverflow.com/questions/45707319/pgadmin-on-windows-10-with-postgres-when-installed-via-bash-on-ubuntu-on-windows>
#### *Preparing the Postgres DB server:*
- Launch pgadmin4
- Create a new role by the name of clickx 
- Provide any password or keep it as empty
- Create two new DBs using the UI with clickx role as the owner:
  - clickx_development
  - clickx_test
- Navigate to the code repository and edit the file: config\database.yml
- For development and test databases, uncomment the line for username and password.
#### *Restore local Postgres DB* 
Download a local instance of 3-4GB dump from Heroku before proceeding with this step. 
You can use the pgrestore command to restore the DB to the local server. In the below command, the jan12.dump file represents the DB downloaded from Heroku.

Steps to download:

- Navigate to the following URL: 
   <https://data.heroku.com/datastores/67b22e96-439b-470c-a6f8-cd297b279f81#durability> 
   - This app and DB is associated with the staging environment.
- On the page, scroll to the section : MANUAL BACKUPS & DATA EXPORTS
- Click on download for the latest backup else click on ‘create manual backup’.
- The new manual backup creation will take 1-2 hours.
- Once the new backup is ready, it will be available for download.

Once the DB is downloaded properly, rename and save the dump file to any location. For example: I saved the file to the folder C:\db\_dump so that it is easily accessible from the command prompt.

Use the following command to restore the local DB to a latest state of the application

pg_restore --verbose --schema=public --no-acl --no-owner --jobs=8 --exit-on-error --username=clickx -f <Name of DB dump file>.dump

#### *Migrate the DB to resolve dependencies*
```sh
rake db:migrate
```
Perform this step once the DB has been restored. This step validates and verifies that the database server is working correctly and the rails app is able to communicate with the DB.
#### *Install other dependencies such as Redis/Memcached*
1. Install Redis:
  - Commands:
```sh
    sudo apt update
    sudo apt install redis-server
    sudo systemctl start redis-server
```
  - Source: <https://linuxize.com/post/how-to-install-and-configure-redis-on-ubuntu-20-04/>

2.  Install Memcached:
  - Commands:
```sh
    sudo apt update
    sudo apt install Memcached
    sudo apt install libmemcached-tools
    sudo systemctl start memcached
```
  - Source: <https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-memcached-on-ubuntu-20-04>

3. Install mimemagic:
  - Commands:
```sh
    - sudo apt update
    - sudo apt install ruby-mimemagic
```
  - Source: <https://www.devmanuals.net/install/ubuntu/ubuntu-16-04-LTS-Xenial-Xerus/how-to-install-ruby-mimemagic.html> 
#### *Managing running services on Ubuntu:*
We can use the sudo systemctl command to manage the running services
#### *Install NodeJS dependencies*
```sh
yarn
```
#### *Run the rails server*
```sh
rails s
```

#### *Access the running application*
Install WSL Utilities from this location: <https://github.com/wslutilities/wslu>
```sh
sudo apt update
sudo apt install ubuntu-wsl
```
Post installation, restart the WSL browser and visit localhost:3000 to get the local running instance using the following command.

- wsl view <http://localhost:3000>

This command should open the provided URL in the default OS browser.

# Resolving post installation issues/warning – backend:
#### .env.sample not exist
Change filename .env.example to .env.sample in root folder
#### *HubSpot access token error*
Add below line in .env file

export HUBSPOT_API_KEY = "asjhdjash"

[comment]: <> (# Resolving post installation issues/warnings on frontend:)

[comment]: <> (The following problems were faced on the front end once the server was up and we were able to access the website in the browser. Most of the errors will be visible once the application is running.)

[comment]: <> (Note: These errors may or may not be encountered by everyone as the code is only related to the front end. These changes are required for the following files in the application.)

[comment]: <> (1. Please navigate to the folder: app/assets/stylesheets)

[comment]: <> (  - reviews.scss)

[comment]: <> (    Commented out the import for “css”)

[comment]: <> (  - rp_custom_leadmagnet.scss)

[comment]: <> (    Added !optional postfix for these 4 entries.)

[comment]: <> (  - uiv2.scss)

[comment]: <> (    Added !optional postfix for these 4 entries.)

[comment]: <> (  - rp_custom.scss)

[comment]: <> (    Added !optional postfix for these 6 entries.)

[comment]: <> (2. Please navigate to the following file: app\models\user.rb)

[comment]: <> (  - Remove the ::Extend from the RailsSettings line)


## To resolve any timeout issues in the local app when debugging errors:
Navigate to the Gemfile and comment out the entry for the gem -> rack_timeout

Please navigate to the file: confing\initializers\rack\_timeout.rb

Comment out the line

## Create a new user to access the website once it loads:
Launch the rails console in the terminal using the command: rails c

Execute the following commands to update a password for the user-123.
```sh
user = User.find(123)
user.password = 'secret_pass' 
user.password_confirmation = 'secret_pass'
user.save
```
Login to the local clickx website using the username/password as 123/secret_pass.
# End notes:
In case, you find any issues, please update the following document.

HAPPY CODING!!
