# requires git, ruby, gem(atk_toolbox), python3, pip3(asciimatics, ruamel.yaml)
require 'atk_toolbox'

# 
# create the file structure if it doesnt exist
# 
FS.makedirs(HOME/"atk"/"installers")
FS.makedirs(HOME/"atk"/"temp")
# download the files
if not FS.exist?(HOME/"atk"/"core.yaml")
    FS.download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/core.yaml'       , to: HOME/"atk"/"core.yaml")
end
if not FS.exist?(HOME/"atk"/"installers.yaml")
    FS.download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/installers.yaml' , to: HOME/"atk"/"installers.yaml")
end

#
# overwrite the commands
# 

# atk
atk_command_download_path = HOME/"atk"/"temp"/"atk.rb"
FS.download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/atk'     , to: atk_command_download_path)
set_command("atk", FS.read(atk_command_download_path))

# project
project_command_download_path = HOME/"atk"/"temp"/"project.rb"
FS.download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/project' , to: project_command_download_path)
set_command("project", FS.read(project_command_download_path))

# @
local_command_download_path = HOME/"atk"/"temp"/"doubledash_command.rb"
FS.download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/@'      , to: local_command_download_path)
set_command("@", FS.read(local_command_download_path))

# 
# print success
# 
puts ""
puts ""
puts ""
puts "=============================="
puts "  ATK installed successfully"
puts "=============================="