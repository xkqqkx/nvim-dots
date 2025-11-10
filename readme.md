Based on [MariaSolOs nvim dotfiles](https://github.com/MariaSolOs/dotfiles/tree/main/.config/nvim).
Requires nvim v0.11 or higher. Binary releases for older architectures can be found [here](https://github.com/neovim/neovim-releases/releases).


## Resources

Learning Neovim Lua involves understanding both the Lua language itself and how Neovim's API interacts with it. Here's a structured approach:

1.  **Learn Lua Fundamentals:**
    *   **Basic Syntax:** Variables, data types (tables are very important in Lua), control structures (if/else, for loops), functions.
    *   **Resources:**
        *   **Programming in Lua (PIL):** The official and comprehensive guide by Lua's creator. Start with the first few chapters.
        *   **Lua Crash Course:** Many online tutorials offer quick introductions.
        *   **`lua.org`:** Official documentation.

2.  **Explore Neovim's Lua API:**
    *   **Neovim Help Files:** This is your primary resource for Neovim-specific functions and options.
        *   `:h lua` - General introduction to Lua in Neovim.
        *   `:h vim.api` - Core API functions (e.g., `vim.api.nvim_set_option`, `vim.api.nvim_command`).
        *   `:h vim.o`, `:h vim.g`, `:h vim.b`, etc. - Accessing Neovim options (global, buffer-local, window-local).
        *   `:h vim.keymap` - Setting keybindings with `vim.keymap.set`.
        *   `:h vim.fn` - Calling built-in Vim functions (e.g., `vim.fn.expand`).
        *   `:h vim.cmd` - Executing Vimscript commands from Lua.
        *   `:h vim.opt` - A more modern way to set options.
    *   **Key Concepts:**
        *   `vim` global table: This is where most Neovim-specific Lua functionality resides.
        *   `nvim_` functions: These are the lower-level API calls, often wrapped by higher-level `vim.` functions for convenience.
        *   Callbacks: Many Neovim functions accept Lua functions as arguments.

## Notes and troubleshooting

- Wrong characters are showing in ssh terminal
  - try `export LANG="en_US.UTF-8"`.
- Folding
  - Set width of fold column to get more friendly representation of fold (e.g., `foldcolumn=4`). See discussion in this [pull request](https://github.com/neovim/neovim/pull/17446).
- Surround plugin
  - for help do `:h nvim-surround.usage`
- LSP
  - Disabled lsp kickstart setup and used one from mariaSOL (`custom/lsp.lua`).
  - There are two ways to interrogate client supported methods: `if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)` which is used by lazy, and `if client:supports_method(methods.textDocument_signatureHelp)` which is used by mariaSOL. The second gives warning and possibly makes problem with markdown (.md) files. Why?
  - When editing neovim configuration we use `.luarc.json` file in project root. It defines paths to various plugins so that LSP is aware of them and can make completion. You may want to disable (remove) it since the presence of this file is checked by the lsp setup `custom/plugins/lspconfig.lua`.
  - starting from neovim 0.11 the `lspconfig` plugin is not required. Lsp server are automatically loaded
from `./lsp` folder
  - to check LSP status (similar to LspInfo command): `checkhealth vim.lsp`

## Log

### 2025-08-08
factored out from my dotfiles

### 2025-11-02
set up of codecompanion for gemini models. The API key can be obtained
- gemini (strajbl@gmail.com) [here](https://aistudio.google.com/usage?timeRange=last-28-days)
- anthropic (strajbl@gmail.com) [here](https://console.anthropic.com/usage?date=2025-10)
- openrouter (strajbl@gmail.com) [here](https://openrouter.ai/activity)

Gemini has free tier for Gemini 2.5 Pro (very slow) and Gemini 2.5 Flash models. For Anthropic I used Haiku 4.5 with prepaid credits.

Openrouter.ai will allow to use paid models until the total cost will reach $1. Then they will ask for money.
Must pay extra care to which models send prompts for training! In privacy settings at openrouter.ai we can select
whether to allow such models or not.


| model                        | openrouter name           | context  | latency (sec) |
| ----                         | ------                    | -------- | ------------- |
| Qwen3 Coder 480B A35B        | qwen/qwen3-coder:free     | 262K     | 68            |
| Qwen3 235B A22B (22B infer)  | qwen/qwen3-235b-a22b:free | 32K      | 3.2           |
| Minimax M2 230B (10B infer)  | minimax/minimax-m2:free   | 204K     | 2.3           |

I tried to make minimax2 run with context sessions (see my [chat with claude](https://claude.ai/chat/73977fd3-1f97-4c08-b708-cbcdef5fea93)) but
needs more work on the config, see codecompanion_minimax2.lua.bak file


### 2025-11-03 Code formatting

To format a selected region of Python code in Neovim with a command (instead of a keymap), define a custom command in your Neovim config (using conform plugin):

````lua
-- filepath: ~/.config/nvim/init.lua
-- ...existing code...
vim.api.nvim_create_user_command("FormatRegion", function()
  local start_mark = vim.api.nvim_buf_get_mark(0, "<")
  local end_mark = vim.api.nvim_buf_get_mark(0, ">")
  require("conform").format({
    async = true,
    range = { start = start_mark, ["end"] = end_mark },
  })
end, { range = true })

-- Optional keymap for convenience
vim.keymap.set("v", "<leader>f", ":FormatRegion<CR>", { desc = "Format selected region" })
````

Usage: 
1. Select text in visual mode (`v`, `V`, or `Ctrl+v`).
2. Run `:FormatRegion`.

To format the entire file in Neovim using conform.nvim, define a command similar to the region formatter:

````lua
-- filepath: ~/.config/nvim/init.lua
-- ...existing code...
vim.api.nvim_create_user_command("FormatFile", function()
  require("conform").format({ async = true })
end, {})

-- Optional keymap (normal mode)
vim.keymap.set("n", "<leader>F", ":FormatFile<CR>", { desc = "Format entire file" })
````

Usage:
- Run `:FormatFile` in normal mode.
- Or press `<leader>F` (e.g., `Space` + `F` if using default leader).

Here's a combined command that formats the selected region (in visual mode) or the entire file (in normal mode):

````lua
-- filepath: ~/.config/nvim/init.lua
-- ...existing code...
vim.api.nvim_create_user_command("Format", function(opts)
  local range = nil
  if opts.range ~= 0 then -- Called with a range (e.g., :'<,'>Format)
    range = {
      start = { opts.line1, 0 },
      ["end"] = { opts.line2, 0 },
    }
  end
  require("conform").format({ async = true, range = range })
end, {
  range = true, -- Allow use with ranges
})

-- Optional keymaps for convenience
vim.keymap.set("n", "<leader>f", ":Format<CR>", { desc = "Format entire file" })
vim.keymap.set("v", "<leader>f", ":Format<CR>", { desc = "Format selected region" })
````

Usage:
- In normal mode: `:Format` or `<leader>f` → formats the whole file.
- In visual mode: Select text, then `:Format` or `<leader>f` → formats only the selection.

This dynamically checks if a range is provided and passes it to conform.nvim. Works with Black (Python) or any formatter set in your conform config.

## 2025-11-08 MCPHub

testing MCP hub pluging which can be used as an extension in codecompanion (see ns1 config)
See this [discussion](https://github.com/ravitemer/mcphub.nvim/discussions/145) for install. I used the yaml suggested by betaboon, then changed the `web_dashboard: false` and `web_dashboard_open_on_launch: false`, and restarted MCP hub.
