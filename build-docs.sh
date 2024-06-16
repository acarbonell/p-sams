#!/bin/bash

mkdocs build --site-dir /var/www/psams --clean
mkdir /var/www/psams/assets
cp -s /data/carrington/data/psams/* /var/www/psams/assets/
