-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  --
  --{ import = "astrocommunity.completion.codeium-nvim" },
  -- { import = "astrocommunity.completion.supermaven-nvim" },
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        accept_suggestion = "<Tab>", -- Назначаем Таб на принятие
        clear_suggestion = "<C-]>", -- Очистить (Ctrl + ])
        accept_word = "<C-j>", -- Принять одно слово (Ctrl + j)
      },
    },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<Tab>"] = { "fallback" }, -- Blink игнорирует Tab, отдавая его Supermaven
      },
    },
  },
}
