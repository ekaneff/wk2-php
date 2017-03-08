# Setup for PHP Project: Pipeline One (Multiple Pipelines Assignment)
#### By Emily Kaneff

This repository is one of three that are part of a multiple pipeline deployment system made with Ansible. The set up and deployment process will be mostly the same in some aspects, but different enough that it is important for you to go through each one carefully and thoroughly as to not leave out any important pieces. 

For this project repository, we will be using Wordpress to demonstrate the set up and deployment of PHP applications using this pipeline system.

>Note: You do not have to install these repositories in order, nor do you need to use them all for the pipeline to work. 

##Table of Contents
* [Set up the VPS](#one)
* [Installing Ansible](#two)
* [Running the Ansible Playbook](#three)
* [Resources](#resources)

<a name="one"></a>
## Step One: Set up the VPS

The first step in this whole process is going to be setting up the Virtual Private Server on Digital Ocean. This is done through their clickable interface on their website. 

1. Create a new Droplet on Digital Ocean
2. For this project we will need version 16.04 of Ubuntu, so select the Ubuntu 16.04 image
3. Choose the size acceptable for your application (in this case, use the $5/mo option)
4. Select a datacenter region that is located closest to you. The numbers represent the number of data centers in that region, and the highest number is just the newest one so it is safe to just select that one.
5. Additional options are recommended but not required. I suggest selecting Backups to allow yourself to roll back to older versions of your server in case any issues arise.
6. For this pipeline to work successfully, you will need to set up SSH key authentication for your VPS. If you do not know how to do this, you can follow this simple [tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets). 
7. Choose a hostname that makes sense for your project and hit CREATE

>This process should be completed twice: once for a staging server and once for a production server. All three projects will be using the same two servers.

<a name="two"></a>
## Step Two: Installing Ansible

The next step will be to install Ansible onto your machine. You can do that with the Homebrew command:

```shell
brew install ansible
```
>Note: If you do not have Homebrew installed, you can find how to do so [here](https://brew.sh/).

After that finishes, if you haven't already, download and place the files from this repository into the root of your project directory. 

<a name="three"></a>
## Step Three: Running the Ansible Playbook

Before running the playbook command, there are a few minor adjustments that need to be made to the playbook files. 

Open the `hosts` file and place the IP address of your Staging and Production servers within that file. Also, under `roles/nginx/vars`, change the variable `stage_ip` to equal that staging IP address.

>If you would like to change the database name, database user and password that will be set up for Maria, the variables can be found in `/roles/maria/vars`

With both those files in place, we can now execute the playbook commands.

The first command you will need to run is: 

```shell
ansible all -m raw -s -a "sudo apt-get -y install python-simplejson" -u root --private-key=~/.ssh/[your ssh key name] -i ./hosts
```
>While setting up the ssh key, you should have at one point setup a name for that key that you could use to reference it. Make sure to place that name in the designated place within the above command.

>Also note that you only need to run this command once for these hosts. So if this is the first project out of the three that you are installing, then run it. If this is not your first project out of the three, skip to the next command

Enter `yes` if prompted.

If your keys were successfully, you should see two success messages about `python` being installed.

The last command you will need to run for this playbook is:

```shell
ansible-playbook --private-key=~/.ssh/[your ssh key name] -i ./hosts php.yml
```
This will begin executing the roles and installing the necessary dependancies to your server. 

This playbook automates the installation and configuration of Nginx and it's server blocks, MariaDB with a new database and user with permissions, PHP7, and Wordpress. It also creates a folder for this project in `/var/www/html` along with a remote bare repository with a post-receive hook in place to handle the files we send from our local machines.

You should now be able to go to `php.[your staging IP].xip.io` and be greeted with the Wordpress installation page. 

>The IP for the production server is something we will have to implement later. For now, only include it in your `hosts` file.

<a name="resources"></a>
##Additional Resources

[How To Use Git Hooks To Automate Development and Deployment Tasks](https://www.digitalocean.com/community/tutorials/how-to-use-git-hooks-to-automate-development-and-deployment-tasks)
