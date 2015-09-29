#!/bin/bash
if [[ -f /etc/lsb-release ]]; then
    os=$DISTRIB_ID
    version=$DISTRIB_RELEASE
else
    os=$(uname -s)
    version=$(sw_vers -productVersion)
fi

install_git () {
    if [[ os -eq "Ubuntu" ]]; then
        sudo apt-get -y install git </dev/null
    fi
}

install_rvm () {
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    rvm install 2.2.1
}

install_bundler () {
    if [[ os -eq "Ubuntu" ]]; then
        if [[ version -eq "14.04" ]]; then
            sudo apt-get -y install bundler </dev/null
        else
            gem install bundler
        fi
    else
        gem install bundler
    fi
}

which git || install_git
which rvm || install_rvm

rvm use 2.2.1
echo "2.2.1" > .ruby-version
echo "source \"https://rubygems.org\"" > Gemfile
echo "gem \"shoperb-theme-editor\", github: \"shoperb/theme-editor\"" >> Gemfile

install_bundler

bundle
