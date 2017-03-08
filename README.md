# Deployment of PHP files to Staging VPS (Multiple Pipelines Assignment)
#### By Emily Kaneff

For this tutorial, we will be using Wordpress files to demonstrate the process of deploying a PHP application to a virtual private server that was set up using Ansible through the use of remote git repositories.

If you have not done so already, follow the tutorial for setting up the VPS using Digital Ocean and Ansible [here](). 

>Note: This is only one of the three pipelines feeding into our servers. The others with setup and deployment instructions can be found at: <br>
>[https://github.com/ekaneff/wk2-static](https://github.com/ekaneff/wk2-static) <br>
>[https://github.com/ekaneff/wk2-node](https://github.com/ekaneff/wk2-node)

##Table of Contents

* [Install Wordpress](#one)
* [Add Git Remote](#two)
* [Push to Git Remote](#three)

<a name="one"></a>
##Step One: Installing Wordpress

To install Wordpress locally, simply follow this [link](https://wordpress.org/download/) to the Wordpress download page and download a zip of the files. Then you simply just take the files from the unzipped wordpress folder and place them in the root of your project directory. 

>If you would like to use other PHP files besides Wordpress, you can. However, keep in mind that in the [set up]() guide, Wordpress was installed on your server through the Ansible playbook. You would need to modify that role to fit your specifications in order for it to work correctly. 

<a name="two"></a>
## Step Two: Adding Remote Connection

When setting up our servers, the automation script went through the process of initializing a bare repository on each server. This repository contains a post-receive hook that will push the files we send to the correct live folder based on the pipeline the files are running through. 

In order to send these files, we need to create a connection locally to that remote repository. We can do this through the Git commands: 

```shell
git remote add PhpStaging ssh://root@[staging ip]:/var/repos/wp.git

git remote add PhpProduction ssh://root@[production ip]:/var/repos/wp.git
```

>Note that the file path at the end must remain the same as I have listed it as that is the naming convention used in the playbook. You can change this if you so wish, you just need to edit the correct line in `repos.sh`. 

## Step Three: Push to Remote

Now that the connection has been created, we can push files up to the server as we please. This is done through the command: 

```shell
git push PhpStaging [local branch]:[remote branch]
```

The local branch in this line will be whatever branch you use in your workflow that contains the version of your files ready for release. 

The remote branch is the branch on your remote repository that you want to hold the files you send. If the branch does not exit, it will be created. 

The `post-receive` hook located in the remote repository (created in our automation script) will handle the transfer of files from the repository to the live folders, so there is no need for you to go in and do it manually. 

Also note that we only pushed to the staging server, and not the production one. Pushing to production would be the same command but with the name of the connection to your remote production repository instead. In our workflow, pushing to production only happens after everything is functional on staging. 

If you would like to check that your files transferred correctly without pulling it up in the browser, you can ssh into your server and look for the changes in `/var/www/html/wordpress`. 

