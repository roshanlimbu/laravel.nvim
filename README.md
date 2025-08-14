# Laravel.nvim (Fork)

This is a fork of the excellent [Laravel.nvim](https://github.com/adalessa/laravel.nvim) plugin by [adalessa](https://github.com/adalessa). 

**Special thanks to adalessa for creating and maintaining the original Laravel.nvim plugin!** This fork builds upon their outstanding work to enhance the Laravel development experience in Neovim.

## Fork Changes

This fork includes the following enhancements:

## Todo 
  - For now I've tested on mac with php8.0 and php8.4 installed. So please check for yourself if this will workout or not.


- **Smart PHP Binary Detection**: Automatically detects and uses the correct PHP version for your project
  - Parses `composer.json` to determine required PHP version
  - Searches for Homebrew versioned PHP binaries (e.g., `/opt/homebrew/opt/php@8.0/bin/php`)
  - Supports fallback compatibility (e.g., uses PHP 8.0+ for Laravel projects requiring PHP 7.3)
  - Eliminates PHP version conflicts and deprecation warnings
- **Default Picker Changed**: Uses `fzf-lua` instead of `telescope` as the default picker
- **Default LSP Server Changed**: Uses `intelephense` instead of `phpactor` as the default LSP server

## Original Project

Plugin for Neovim to enhance the development experience of Laravel projects

Quick executing of artisan commands, list and navigate to routes. Information about the routes.
Robust API to allow you to run any command in the way that you need.

For more information, see the [official documentation](https://adalessa.github.io/laravel-nvim-docs/)

## Original Author

The original Laravel.nvim plugin was created and maintained by [Ariel Adalessa](https://github.com/adalessa). Please show support for their work by:
- Starring the [original repository](https://github.com/adalessa/laravel.nvim)
- Subscribing to their [YouTube channel](https://youtube.com/@Alpha_Dev)
- Supporting them as a YouTube member if you find their content valuable

## Installation

### Using lazy.nvim

```lua
{
  "roshanlimbu/laravel.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-dotenv",
    "MunifTanjim/nui.nvim",
    "nvimtools/none-ls.nvim",
  },
  cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
  keys = {
    { "<leader>la", ":Laravel artisan<cr>" },
    { "<leader>lr", ":Laravel routes<cr>" },
    { "<leader>lm", ":Laravel related<cr>" },
  },
  event = { "VeryLazy" },
  config = true,
}
```

### PHP Version Configuration

This fork automatically detects the correct PHP version for your project. You can also manually specify the PHP binary:

1. **Project-specific**: Create a `.nvim-php-bin` file in your project root:
   ```
   /opt/homebrew/opt/php@8.0/bin/php
   ```

2. **Environment variable**: Set `LARAVEL_NVIM_PHP_BIN`:
   ```bash
   export LARAVEL_NVIM_PHP_BIN="/opt/homebrew/opt/php@8.0/bin/php"
   ```

## Breaking Changes

I have re-written most of the plugin so in case you need to stay in an old version use the tagged version `v2.2.1` and not master.

# Collaboration
I am open to review pr if you have ideas or ways to improve the plugin would be great.
