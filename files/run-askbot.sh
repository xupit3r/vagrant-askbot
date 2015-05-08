#!/bin/bash

# move into the ab directory (where all this
# stuff is n'at)
cd  /home/vagrant/ab

# start the askbot server
python manage.py runserver `hostname -i`:8000