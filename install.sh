#!/bin/bash

case $(uname) in
    Ubuntu)
        which git || sudo apt-get install git
        ;;
esac

function install_rvm {
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    rvm install 2.2.1
    /bin/bash --login
}
which rvm || install_rvm
rvm use 2.2.1
echo "2.2.1" > .ruby-version
echo "source \"https://rubygems.org\"" > Gemfile
echo "gem \"shoperb-theme-editor\", github: \"shoperb/theme-editor\"" >> Gemfile
gem install bundler
bundle
