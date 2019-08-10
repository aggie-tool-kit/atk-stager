# requires git, ruby, gem(atk_toolbox), python3, pip3(asciimatics, ruamel.yaml)
require 'atk_toolbox'

# 
# create the file structure if it doesnt exist
# 
FileUtils.makedirs(HOME/"atk"/"installers")
FileUtils.makedirs(HOME/"atk"/"temp")
# download the files
if not File.exist?(HOME/"atk"/"core.yaml")
    download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/core.yaml'       , as: HOME/"atk"/"core.yaml")
end
if not File.exist?(HOME/"atk"/"installers.yaml")
    download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/installers.yaml' , as: HOME/"atk"/"installers.yaml")
end

#
# overwrite the commands
# 

# atk
atk_command_download_path = HOME/"atk"/"temp"/"atk.rb"
download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/atk'     , as: atk_command_download_path)
set_command("atk", IO.read(atk_command_download_path))

# project
project_command_download_path = HOME/"atk"/"temp"/"project.rb"
download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/project' , as: project_command_download_path)
set_command("project", IO.read(project_command_download_path))

# >
local_command_download_path = HOME/"atk"/"temp"/"doubledash_command.rb"
download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/>'      , as: local_command_download_path)
set_command(">", IO.read(local_command_download_path))

# 
# print success
# 
puts ""
puts ""
puts ""
puts "=============================="
puts "  ATK installed successfully"
puts "=============================="