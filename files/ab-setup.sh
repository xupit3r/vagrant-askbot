#!/bin/bash

# move into the ab directory (where all this
# stuff is n'at)
cd  /home/vagrant/ab

# copy files
python manage.py collectstatic <<< yes

# setup tables
python manage.py syncdb <<< no

# do general table migration
python manage.py migrate askbot

# setup stuff for openid
python manage.py migrate django_authopenid

# finalize migration
python manage.py syncdb --migrate --noinput