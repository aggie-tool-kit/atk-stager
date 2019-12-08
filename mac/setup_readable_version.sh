function is_command { command -v "$@" >/dev/null 2>& }
# ask for password early on
sudo echo ""
# install homebrew if not installed
is_command brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# create the temp dir
mkdir -p ~/atk/temp
# install git if needed
is_command git || brew install git
# install ruby 2.5.5
is_command rbenv || brew install rbenv
rbenv versions | grep '2.5.5' || rbenv install 2.5.5
rbenv global 2.5.5
# put rbenv init in profiles
touch ~/.bash_profile
touch ~/.zshenv
cat ~/.bash_profile | grep "eval \"\$(rbenv init -)\"" || echo "is_command rbenv && eval \"\$(rbenv init -)\" # setup for ruby" >> ~/.bash_profile
cat ~/.zshenv | grep "eval \"\$(rbenv init -)\"" || echo "is_command rbenv && eval \"\$(rbenv init -)\" # setup for ruby" >> ~/.zshenv
rbenv init &>/dev/null
alias ruby="$(rbenv which ruby)"
alias gem="$(rbenv which gem)"
# create a symlink to ruby to prevent bugs in random applications
ln -s \"/Users/$(whoami)/.rbenv/shims/ruby\" /usr/local/bin/ruby
# install the atk_toolbox gem
"$(rbenv which gem)" install atk_toolbox
# download the setup.rb
curl -fsSL https://raw.githubusercontent.com/aggie-tool-kit/atk-stager/master/setup.rb > ~/atk/temp/setup.rb
# run it
"$(rbenv which ruby)" ~/atk/temp/setup.rb
rm ~/atk/temp/setup.rb