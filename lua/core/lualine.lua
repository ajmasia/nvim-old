-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require("lualine")
local icons = require("core.icons")
local function has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#303030',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local mode_color = {
	n = colors.yellow,
	i = colors.green,
	v = colors.blue,
	[""] = colors.blue,
	V = colors.blue,
	c = colors.green,
	no = colors.red,
	s = colors.orange,
	S = colors.orange,
	[""] = colors.orange,
	ic = colors.yellow,
	R = colors.violet,
	Rv = colors.violet,
	cv = colors.red,
	ce = colors.red,
	r = colors.cyan,
	rm = colors.cyan,
	["r?"] = colors.cyan,
	["!"] = colors.red,
	t = colors.red,
}

local mode_icon = {
	n = "",
	i = "",
	v = "",
	[""] = "",
	V = "",
	c = "",
	no = "",
	s = "",
	S = "",
	[""] = "",
	ic = "",
	R = "",
	Rv = "",
	cv = "",
	ce = "",
	r = "",
	rm = "",
	["r?"] = "",
	["!"] = "",
	t = "",
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 150
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

-- Config
local config = {
	options = {
		-- Disable sections and component separators
		icons_enabled = true,
		component_separators = "",
		section_separators = "",
		-- theme = {
		-- We are going to use lualine_c an lualine_x as left and
		-- right section. Both are highlighted by c theme .  So we
		-- are just setting default looks o statusline
		-- 	normal = { c = { fg = colors.fg, bg = colors.bg } },
		-- 	inactive = { c = { fg = colors.fg, bg = colors.bg } },
		-- },
		disabled_filetypes = { "packer", "NvimTree", "alpha" },
	  theme = "tokyonight",
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return "▊"
	end,
	color = function()
		return { fg = mode_color[vim.fn.mode()] }
	end,
	padding = 0,
})

-- ins_left({
-- 	"mode",
-- 	cond = conditions.hide_in_width,
-- })

ins_left({
	"branch",
	icon = "",
	color = { fg = colors.green, gui = "bold" },
})

-- ins_left({
-- 	-- filesize component
-- 	"filesize",
-- 	cond = conditions.buffer_not_empty,
-- })

ins_left({
	function()
		function Split(s, delimiter)
			result = {}
			for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
				table.insert(result, match)
			end
			return result
		end

		local root = require("project_nvim.project").get_project_root()
		local path = Split(root, "/")
		return path[#path]
	end,
	icon = "",
	color = { fg = colors.violet, gui = "bold" },
	-- cond = conditions.hide_in_width,
})

ins_left({
	"filename",
	icon = "",
	cond = conditions.buffer_not_empty,
	color = { fg = colors.magenta, gui = "bold" },
})

ins_left({
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = " ", modified = "柳 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	-- cond = conditions.hide_in_width,
})

ins_right({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn", "info", "hint" },
	symbols = {
		error = "" .. icons.diagnostics.Error .. " ",
		warn = "" .. icons.diagnostics.Warning .. " ",
		info = "" .. icons.diagnostics.Information .. " ",
		hint = "" .. icons.diagnostics.Hint .. " ",
	},
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.cyan },
	},
	-- always_visible = true,
})

ins_right({
	-- Lsp server name .
	function(msg)
		msg = msg or icons.lsp.disconnect .. " LSP"
		local buf_clients = vim.lsp.buf_get_clients()
		if next(buf_clients) == nil then
			-- TODO: clean up this if statement
			if type(msg) == "boolean" or #msg == 0 then
				return icons.lsp.disconnect .. " LSP"
			end
			return msg
		end
		local buf_ft = vim.bo.filetype
		local buf_client_names = {}

		-- add client
		for _, client in pairs(buf_clients) do
			if client.name ~= "null-ls" then
				if client.name == "eslint" then
					table.insert(buf_client_names, icons.lsp.linter .. " " .. client.name)
					break
				end
				table.insert(buf_client_names, icons.lsp.lang .. client.name)
			end
		end

		local sources = require("null-ls.sources")
		local available_sources = sources.get_available(buf_ft)
		local registered = {}

		for _, source in ipairs(available_sources) do
			for method in pairs(source.methods) do
				registered[method] = registered[method] or {}

				if method == "NULL_LS_FORMATTING" then
					table.insert(registered[method], icons.lsp.formatter .. " " .. source.name)
					break
				end

				if method == "NULL_LS_DIAGNOSTICS" then
					table.insert(registered[method], icons.lsp.linter .. " " .. source.name)
					break
				end

				table.insert(registered[method], source.name)
			end
		end

		local formatters = registered[require("null-ls").methods.FORMATTING] or {}
		local linters = registered[require("null-ls").methods.DIAGNOSTICS] or {}

		vim.list_extend(buf_client_names, formatters)
		vim.list_extend(buf_client_names, linters)

		return table.concat(buf_client_names, " ")
	end,
	-- function()
	-- 	local msg = "Inactive"
	-- 	local buf_clients = vim.lsp.buf_get_clients()
	-- 	if next(buf_clients) == nil then
	-- 		-- TODO: clean up this if statement
	-- 		if type(msg) == "boolean" or #msg == 0 then
	-- 			return "LS Inactive"
	-- 		end
	-- 		return msg
	-- 	end
	-- 	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	-- 	local clients = vim.lsp.get_active_clients()
	-- 	local buf_client_names = {}
	-- 	if next(clients) == nil then
	-- 		return msg
	-- 	end

	-- 	for _, client in pairs(clients) do
	-- 		local filetypes = client.config.filetypes
	-- 		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
	-- 			if client.name ~= "null-ls" then
	-- 				if has_value(table, client.name) == false then
	-- 					table.insert(buf_client_names, client.name)
	-- 				end
	-- 			end
	-- 		end
	-- 	end

	-- 	local sources = require("null-ls.sources")
	-- 	local available_sources = sources.get_available(buf_ft)
	-- 	local registered = {}

	-- 	for _, source in ipairs(available_sources) do
	-- 		for method in pairs(source.methods) do
	-- 			registered[method] = registered[method] or {}
	-- 			table.insert(registered[method], source.name)
	-- 		end
	-- 	end

	-- 	local formatters = registered[require("null-ls").methods.FORMATTING] or {}
	-- 	local linters = registered[require("null-ls").methods.LINTERS] or {}

	-- 	vim.list_extend(buf_client_names, formatters)
	-- 	vim.list_extend(buf_client_names, linters)

	-- 	return "[" .. table.concat(buf_client_names, ", ") .. "]"
	-- end,
	-- icon = " ",
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	"filetype",
	cond = conditions.buffer_not_empty,
	color = { fg = colors.blue, bg = colors.bg, gui = "bold" },
	icon_only = false,
})

-- Add components to right sections
-- ins_right({
-- 	"o:encoding", -- option component same as &encoding in viml
-- 	fmt = string.upper, -- I'm not sure why it's upper case either ;)
-- 	cond = conditions.hide_in_width,
-- 	color = { fg = colors.green, gui = "bold" },
-- })

-- ins_right({
-- 	"fileformat",
-- 	fmt = string.upper,
-- 	icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
-- 	color = { fg = colors.green, gui = "bold" },
-- })

-- ins_right({
-- 	function()
-- 		return "▊"
-- 	end,
-- 	color = { fg = colors.blue },
-- 	padding = { left = 1 },
-- })

-- Now don't forget to initialize lualine
lualine.setup(config)
