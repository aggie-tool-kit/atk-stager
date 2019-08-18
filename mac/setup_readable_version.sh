# ask for password early on
sudo echo ""
# install homebrew if not installed
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# create the temp dir
mkdir -p ~/atk/temp
# install git if needed
which git || brew install git
# install ruby 2.5.5
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
rbenv versions | grep '2.5.5' || echo 'installing ruby 2.5.5... this might take a little bit' && rbenv install 2.5.5
rbenv init
rbenv global 2.5.5
# install the atk_toolbox gem
gem install atk_toolbox
# download the setup.rb
curl -fsSL https://raw.githubusercontent.com/aggie-tool-kit/atk/master/setup/setup.rb > ~/atk/temp/setup.rb
# run it
ruby ~/atk/temp/setup.rb
rm ~/atk/temp/setup.rb