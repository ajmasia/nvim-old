-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- find more here: https://www.nerdfonts.com/cheat-sheet
local icons = {
	kind = {
		Class = " ",
		Color = " ",
		Constant = "ﲀ ",
		Constructor = " ",
		Enum = "練",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = "",
		Folder = " ",
		Function = " ",
		Interface = "ﰮ ",
		Keyword = " ",
		Method = " ",
		Module = " ",
		Operator = "",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		Struct = " ",
		Text = " ",
		TypeParameter = " ",
		Unit = "塞",
		Value = " ",
		Variable = " ",
	},
	type = {
		Array = "",
		Number = "",
		String = "",
		Boolean = "蘒",
		Object = "",
	},
	documents = {
		File = "",
		Files = "",
		Folder = "",
		OpenFolder = "",
	},
	git = {
		Add = "",
		Mod = "",
		Remove = "",
		Ignore = "",
		Rename = "",
		Diff = "",
		Repo = "",
	},
	ui = {
		Lock = "",
		Circle = "",
		BigCircle = "",
		BigUnfilledCircle = "",
		Close = "",
		NewFile = "",
		Search = "",
		Lightbulb = "",
		Project = "",
		Dashboard = "",
		History = "",
		Comment = "",
		Bug = "",
		Code = "",
		Telescope = "",
		Gear = "",
		Package = "",
		List = "",
		SignIn = "",
		Check = "",
		Fire = "",
		Note = "",
		BookMark = "",
		Pencil = "",
		-- ChevronRight = "",
		ChevronRight = ">",
		Table = "",
		Calendar = "",
	},
	diagnostics = {
		Error = "",
		Warning = "",
		Information = "",
		Question = "",
		Hint = "",
	},
	misc = {
		Robot = "ﮧ",
		Squirrel = "",
		Tag = "",
		Watch = "",
	},
	lsp = {
		lang = "歷",
		formatter = "",
		linter = "",
		disconnect = "",
	},
}

return icons
