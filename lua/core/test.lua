function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local root = require "project_nvim.project".get_project_root()
local path = Split(root, "/")
print(path[#path])

