local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = {
		"bash",
		"javascript",
		"json",
		"lua",
		"python",
		"typescript",
		"css",
		"rust",
		"yaml",
		"nix",
	},
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		-- use_languagetree = true,
		enable = true, -- false will disable the whole extension
		-- disable = { "css", "html" }, -- list of language that will be disabled
		disable = { "latex" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "yaml" } },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
		config = {
			-- Languages that have a single comment style
			typescript = "// %s",
			css = "/* %s */",
			scss = "/* %s */",
			html = "<!-- %s -->",
			svelte = "<!-- %s -->",
			vue = "<!-- %s -->",
			json = "// %s",
		},
	},
	autotag = {
		enable = true,
		disable = { "xml" },
	},
	playground = {
		enable = true,
	},
  textobjects = {
    swap = {
      enable = false,
      -- swap_next = textobj_swap_keymaps,
    },
    -- move = textobj_move_keymaps,
    select = {
      enable = false,
      -- keymaps = textobj_sel_keymaps,
    },
  },
  textsubjects = {
    enable = false,
    keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
  },
  rainbow = {
    enable = false,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  },

})
