Altamira
========

[![Build Status](https://travis-ci.org/nsrr/altamira.svg?branch=master)](https://travis-ci.org/nsrr/altamira)
[![Dependency Status](https://gemnasium.com/nsrr/altamira.svg)](https://gemnasium.com/nsrr/altamira)
[![Code Climate](https://codeclimate.com/github/nsrr/altamira/badges/gpa.svg)](https://codeclimate.com/github/nsrr/altamira)


A rack app aimed at fast EDF drawing using HTML and JavaScript.

## Installation

[Prerequisites Install Guide](https://github.com/remomueller/documentation): Instructions for installing prerequisites like Ruby, Git, JavaScript compiler, etc.

Once you have the prerequisites in place, you can proceed to install bundler which will handle most of the remaining dependencies.

```
gem install bundler
```

This readme assumes the following installation directory: /var/www/altamira

```
cd /var/www

https://github.com/nsrr/altamira.git

cd altamira

bundle install

ln -s /var/www/www.sleepdata.org/carrierwave/datasets datasets
```

Create a `.sleepdata.yml` file that contains:

```
# The www.sleepdata.org server location
url: http://localhost/sleepdata
# The assets path location, to allow assets to be referenced correctly
url: /altamira
# This refers to the symbolic link for the sleepdata datasets
location: datasets
```

To install new updates run:

```
git pull
bundle update
touch tmp/restart.txt
```


Run Rails Server (or use Apache or nginx)

```
rails s -p80
```

Open a browser and go to: [http://localhost](http://localhost)

All done!
