# requires git, ruby, gem(atk_toolbox), python3, pip3(asciimatics, ruamel.yaml)
require 'atk_toolbox'

# 
# create the file structure if it doesnt exist
# 
FS.makedirs(HOME/"atk"/"installers")
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
atk_command_download_path = ATK.temp_path("atk.rb")
FS.download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/atk'     , to: atk_command_download_path)
set_command("atk", FS.read(atk_command_download_path))

# project
project_command_download_path = ATK.temp_path("project.rb")
FS.download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/project' , to: project_command_download_path)
set_command("project", FS.read(project_command_download_path))

# the project run alias
local_command_download_path = ATK.temp_path("local_command.rb")
FS.download('https://raw.githubusercontent.com/aggie-tool-kit/atk/master/_'      , to: local_command_download_path)
set_command("_", FS.read(local_command_download_path))

# 
# print success
# 
puts ""
puts ""
puts ""
puts "=============================="
puts "  ATK installed successfully"
puts "=============================="