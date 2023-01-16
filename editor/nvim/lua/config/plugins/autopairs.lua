return {
	"windwp/nvim-autopairs",
	config = function()
		local autopairs = require("nvim-autopairs")
		autopairs.setup({})
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp_status_ok, cmp = pcall(require, "cmp")
		if not cmp_status_ok then
			return
		end

		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
