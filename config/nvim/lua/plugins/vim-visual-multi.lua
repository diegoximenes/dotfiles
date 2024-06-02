return {
	"mg979/vim-visual-multi",
	init = function ()
		vim.g.VM_maps = {
			["Find Under"] = "<C-t>",
			["Find Subword Under"] = "<C-t>",
			["Add Cursor Down"] = "<F1>",
			["Add Cursor Up"] = "<F2>",
		}
	end
}
