#!/bin/sh

apt-get clean && apt-get update

echo 'increasing the memory for apt'
echo 'APT::Cache-Limit "516777216";' >> /etc/apt/apt.conf.d/70debconf

echo 'running ubuntu_install.sh'
rm -rf /usr/local/src/*

echo 'updating apt'
apt-get update
# Get the essentials
echo 'building essentials'
apt-get -y install build-essential

echo 'Installing git'
apt-get -y install git-core rsync

# Install ruby
echo 'Installing ruby...'
apt-get -y install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8
ln -sf /usr/bin/ruby1.8 /usr/local/bin/ruby
ln -sf /usr/bin/ri1.8 /usr/local/bin/ri
ln -sf /usr/bin/rdoc1.8 /usr/local/bin/rdoc
ln -sf /usr/bin/irb1.8 /usr/local/bin/irb

# Install rubygems
echo '-- Installing Rubygems'
# if [[ ! -f /usr/local/src/rubygems-1.1.1 ]]; then
  cd /usr/local/src
  wget http://rubyforge.org/frs/download.php/35283/rubygems-1.1.1.tgz
  tar -xzf rubygems-1.1.1.tgz
  rm rubygems-1.1.1.tgz
  cd rubygems-1.1.1  
  ruby setup.rb --no-rdoc --no-ri
  ln -sf /usr/bin/gem1.8 /usr/bin/gem
# fi

# Install gems
# if [[ which pool | grep -v "bin" ]]; then
  gem update --system
  gem install SQS aws-s3 amazon-ec2 aska rake poolparty --no-rdoc --no-ri --no-test
# fi

# Install haproxy
# if [[ which haproxy | grep -v "bin" ]]; then
  apt-get -y install haproxy
  echo 'Configuring haproxy logging'
  sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/haproxy
  sed -i 's/SYSLOGD=\"\"/SYSLOGD=\"-r\"/g' /etc/default/syslogd
  echo 'local0.* /var/log/haproxy.log' >> /etc/syslog.conf && /etc/init.d/sysklogd restart
  /etc/init.d/haproxy restart
# fi
# Install heartbeat
# if [[ which heartbeat | grep -v "bin" ]]; then
  apt-get -y install heartbeat-2
# fi

# Install monit
# if [[ which monit | grep -v "bin" ]]; then
  apt-get -y install monit
  sudo mkdir /etc/monit
  sed -i 's/startup=0/startup=1/g' /etc/default/monit
  /etc/init.d/monit start
# fi

# Install s3fuse
# if [[ which s3fs | grep -v "bin" ]]; then
  apt-get install -y libcurl4-openssl-dev libxml2-dev libfuse-dev
  cd /usr/local/src && wget http://s3fs.googlecode.com/files/s3fs-r166-source.tar.gz 
  tar -zxf s3fs-r166-source.tar.gz
  cd s3fs/ && make
  mv s3fs /usr/bin
# fi  

echo ' - installed from script!'