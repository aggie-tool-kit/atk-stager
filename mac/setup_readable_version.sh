# ask for password early on
sudo echo ""
# install homebrew if not installed
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# create the temp dir
mkdir -p ~/atk/temp
# install git if needed
which git || brew install git
# install ruby 2.5.5
which rbenv || brew install rbenv
rbenv versions | grep '2.5.5' || rbenv install 2.5.5
# put rbenv init in profiles
touch ~/.bash_profile
touch ~/.zshenv
cat ~/.bash_profile | grep "eval \"\$(rbenv init -)\"" || echo "which rbenv && eval \"\$(rbenv init -)\" # setup for ruby" >> ~/.bash_profile
cat ~/.zshenv | grep "eval \"\$(rbenv init -)\"" || echo "which rbenv && eval \"\$(rbenv init -)\" # setup for ruby" >> ~/.zshenv
rbenv init &>/dev/null
alias ruby="$(rbenv which ruby)"
alias gem="$(rbenv which gem)"
rbenv global 2.5.5
# install the atk_toolbox gem
gem install atk_toolbox
# download the setup.rb
curl -fsSL https://raw.githubusercontent.com/aggie-tool-kit/atk/master/setup/setup.rb > ~/atk/temp/setup.rb
# run it
ruby ~/atk/temp/setup.rb
rm ~/atk/temp/setup.rb