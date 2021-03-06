#!/usr/bin/perl
use strict;
use warnings;

print "starting perl script\n";

sub bash {
    my @args = ( "bash", "-c", shift );
    system(@args);
}

sub is_a_command {
    my $command_name = $_[0];
    if (`which $command_name` eq "") {
        return 0;
    } else {
        return 1;
    }
}

sub install_python3_and_pip3_if_needed {
    if (not is_a_command("python3")) {
        if (is_a_command("apt-get")) {
            bash "sudo apt-get install python3 <<<'Y'";
        } else {
            die "Sadly your distro isn't supported yet :/";
        }
    }
    if (not is_a_command("pip3")) {
        if (is_a_command("apt-get")) {
            bash "sudo apt-get install python3-pip <<<'Y'";
        } else {
            die "Sadly your distro isn't supported yet :/";
        }
    }
}

sub ruby_version {
    my $version = `ruby -v`;
    # reduce it down to just the numbers
    $version =~ s/.+?(\d.+?) .+/$1/;
    return $version;
}

sub has_ruby_that_is_at_least {
    # check if ruby is avalible
    if (is_a_command("ruby")) {
        my $version = ruby_version();
        if ($version =~ /(\d+)\.(\d+)\./) {
            my $major_number = int($1);
            my $minor_number = int($2);
            if ($major_number lt $_[0]) {
                return 0;
            } elsif ($minor_number lt $_[1]) {
                return 0;
            } else {
                return 1;
            }
        }
    }
    return 0;
}

sub install_ruby_if_needed {
    if (not has_ruby_that_is_at_least(2,5)) {
        # if ubuntu, install ruby
        if (is_a_command("apt-get")) {
            bash "sudo apt-get install ruby <<<'Y'";
        } else {
            die "Sadly your distro isn't supported yet :/";
        }
    }
}

sub install_atk_toolbox {
    bash "sudo gem install atk_toolbox";
}

sub install_asciimatics {
    if (`pip3 freeze | perl -0pe 's/[\\s\\S]*asciimatics[\\s\\S]*/true/g'` ne "true") {
        bash "sudo pip3 install asciimatics";
    }
}

sub install_ruamelyaml {
    if (`pip3 freeze | perl -0pe 's/[\\s\\S]*ruamel\\.yaml[\\s\\S]*/true/g'` ne "true") {
        bash "sudo pip3 install ruamel.yaml";
    }
}

sub install_git_if_needed {
    if (not is_a_command("git")) {
        if (is_a_command("apt-get")) {
            bash "sudo apt-get install git <<<'Y'";
        } else {
            die "Sadly your distro isn't supported yet :/";
        }
    }
}

# 
# update if needed
# 
if (is_a_command("apt")) {
    bash "sudo apt update";
}

# 
# pre-reqs for setup.rb
# 
install_git_if_needed();
install_ruby_if_needed();
install_atk_toolbox();

# 
# run the setup
# 
bash <<'HEREDOC';
    ruby -e 'require File.dirname(Gem.find_latest_files("atk_toolbox")[0])+"/after_gem_update.rb"'
HEREDOC