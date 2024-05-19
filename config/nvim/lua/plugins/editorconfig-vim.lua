return {
	"editorconfig/editorconfig-vim",
	config = function()
		vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }
		vim.g.EditorConfig_disable_rules = { "trim_trailing_whitespace" }
	end,
}
