# Setup

1. make sure that you have [Vagrant](www.vagrantup.com) and [Virtual Box](www.virtualbox.org/) installed
2. set your skin name (`SKIN_NAME`) to the desired name in the `Vagrantfile`
3. in this directory type `vagrant up` (this will begin the setup and provisioning of the virtual machine)
4. after setup and provisioning is complete, log into the machine by typing `vagrant ssh`
5. navigate to `/home/vagrant/ab` and execute the following command `ab-setup`
6. once the command has completed, you can run the server by executing `run-askbot`

# Use

This is expected to be used in conjunction with the development of askbot skins. For an example of a skin structure, see the [AskPGH theme](https://github.com/openpgh/askpgh-theme).
