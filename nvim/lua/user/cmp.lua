local cmp = require'cmp'
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },

    mapping = {
        ["<M-k>"] = cmp.mapping.select_prev_item(),
        ["<M-j>"] = cmp.mapping.select_next_item(),
        ["<M-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ["<M-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ["<M-Space>"] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ["<M-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<M-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<TAB>'] = cmp.mapping.confirm({ select = true }),
    },

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        -- { name = "buffer" },
        -- { name = "luasnip" },
        -- { name = "path" },
    }),

    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            maxwidth = 50,
        })
    },

    experimental = {
        native_menu = false,
        ghost_text = false,
    },
})
