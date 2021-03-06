local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

--local snip_status_ok, luasnip = pcall(require, "luasnip")
--if not snip_status_ok then
--  return
--end


 -- require("luasnip/loaders/from_vscode").lazy_load()
--local check_backspace = function()
--  local col = vim.fn.col "." - 1
--  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
--end

--   פּ ﯟ   some other good icons
local icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup {
    experimental = {
        native_menu = false,
        ghost_text = false,
    },
    confirmation = {
        get_commit_characters = function()
            return {}
        end,
    },
    completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        keyword_length = 1,
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, vim_item)
            vim_item.menu = vim_item.kind
            vim_item.kind = icons[vim_item.kind]

            return vim_item
        end,
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-q>"] = cmp.mapping.close(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<Plug>(vsnip-expand-or-jump)", true, true, true),
                    "",
                    true
                )
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true),
                    "",
                    true
                )
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "vsnip" },
        {name = "luasnip"},
        { name = "path" },
        { name = "buffer" },
    },
    preselect = cmp.PreselectMode.None,
}

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})
