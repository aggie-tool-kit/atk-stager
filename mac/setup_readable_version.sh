function is_command { command -v "$@" >/dev/null 2>&1; }
# ask for password early on
sudo echo "" || exit
# install homebrew if not installed
is_command brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# create the temp dir
mkdir -p ~/atk/temp
# install git if needed
is_command git || brew install git
# install ruby 2.5.5
is_command rbenv || brew install rbenv
# update rbenv if needed
rbenv install --list | grep '^2.5.5' &>/dev/null || brew upgrade rbenv
# install ruby 2.5.5 if needed
rbenv versions | grep '2.5.5' &>/dev/null || rbenv install 2.5.5
rbenv global 2.5.5
# put rbenv init in profiles
touch ~/.bash_profile
touch ~/.zshenv
cat ~/.bash_profile | grep "eval \"\$(rbenv init -)\"" &>/dev/null || echo "is_command rbenv && eval \"\$(rbenv init -)\" # setup for ruby" >> ~/.bash_profile
cat ~/.bash_profile | grep "atk___completions"  &>/dev/null || echo 'atk___completions() { COMPREPLY=($(compgen -W "$(ruby -e '"'"'require File.dirname(Gem.find_latest_files("atk_toolbox")[0])+"/atk/autocomplete.rb"; Atk.autocomplete("_")'"'"')" "${COMP_WORDS[1]}")); };complete -F atk___completions _' >> ~/.bash_profile
cat ~/.zshenv | grep "eval \"\$(rbenv init -)\""  &>/dev/null || echo "is_command rbenv && eval \"\$(rbenv init -)\" # setup for ruby" >> ~/.zshenv
rbenv init &>/dev/null
alias ruby="$(rbenv which ruby)"
alias gem="$(rbenv which gem)"
# create a symlink to ruby to prevent bugs in random applications
rm -rf /usr/local/bin/ruby
ln -s \"/Users/$(whoami)/.rbenv/shims/ruby\" /usr/local/bin/ruby
# install the atk_toolbox gem
gem install atk_toolbox