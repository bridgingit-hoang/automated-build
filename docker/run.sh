#! /bin/bash

exec forever start -c coffee /var/www/tracking/gt.coffee >> /tracking/tracking.log 2>&1