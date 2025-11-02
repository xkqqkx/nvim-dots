Based on [MariaSolOs nvim dotfiles](https://github.com/MariaSolOs/dotfiles/tree/main/.config/nvim).
Requires nvim v0.11 or higher. Binary releases for older architectures can be found [here](https://github.com/neovim/neovim-releases/releases).

## Notes

starting from neovim 0.11 the `lspconfig` plugin is not required. Lsp server are automatically loaded
from `./lsp` folder
- to check LSP status (similar to LspInfo command): `checkhealth vim.lsp`

## Log

### 2025-08-08
factored out from my dotfiles

### 2025-11-02
set up of codecompanion for gemini models. The API key can be obtained
- gemini [here](https://aistudio.google.com/usage?timeRange=last-28-days)
- anthropic [here](https://console.anthropic.com/usage?date=2025-10)

Gemini has free tier for Gemini 2.5 Pro (very slow) and Gemini 2.5 Flash models. For Anthropic I used Haiku 4.5 with prepaid credits.
