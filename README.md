Clark
=====

This is the codebase for the web application that runs the WalnutNHS website ([walnutnhs.com](http://walnutnhs.com/)).

Installation
------------

Clark has a couple dependencies that need to be installed before it can be deployed. The instructions here are for deploying on a Ubuntu Linux Server 11.04.

    # Install Ruby

    apt-get update
    apt-get install ruby ri rdoc irb -y

    # Install RubyGems (latest version from source)

    wget http://rubyforge.org/frs/download.php/74954/rubygems-1.8.5.tgz
    tar -xvf rubygems-1.8.5.tgz
    cd rubygems-1.8.5
    ruby ./setup.rb
    ln -s /usr/bin/gem1.8 /usr/bin/gem

    # Install ImageMagick

    apt-get install imagemagick

    # Install Bundler
    
    gem install bundler

    # Download Clark from GitHub

    cd ~ # optional
    git clone git://github.com/rogerhub/Clark.git

    # Run Bundler to install necessary gems

    cd clark
    bundle install
    
    #

    # Run Clark server or setup with Phusion Passenger

    rails server -p 80

Support
-------

Roger's Clark development blog is located at [walnutnhs.com/dev](http://walnutnhs.com/dev). If your installation encounters errors, or if you are interested in deploying Clark with another school, contact Roger at [rogerhub.com](http://rogerhub.com/about-the-blogger).