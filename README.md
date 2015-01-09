# Setup

1. make sure that you have [Vagrant](www.vagrantup.com) and [Virtual Box](www.virtualbox.org/) installed
2. set your skin name (`SKIN_NAME`) to the desired name in the `Vagrantfile`
3. in this directory type `vagrant up` (this will begin the setup and provisioning of the virtual machine)
4. after setup and provisioning is complete, log into the machine by typing `vagrant ssh`
5. navigate to `/home/vagrant/ab` and execute the following command `sudo ./ab-setup.sh`
6. once the command has completed, open `settings.py` and ensure that following lines are properly set (replace `<skin_name>` with your skin name, i.e. what you set in step 2 above) 

```
    ASKBOT_EXTRA_SKINS_DIR = os.path.join(os.path.dirname(__file__), 'askbot/skins')
    STATICFILES_DIRS = (
        ('default/media', os.path.join(ASKBOT_ROOT, 'media')),
        ('<skin_name>', ASKBOT_EXTRA_SKINS_DIR)),
        ('<skin_name>/media', os.path.join(ASKBOT_EXTRA_SKINS_DIR, '<skin_name>/media'))
    )
```
