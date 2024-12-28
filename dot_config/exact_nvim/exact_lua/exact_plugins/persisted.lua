return {
  'olimorris/persisted.nvim',
  lazy = false,
  config = function()
    require('persisted').setup({
      autoload = true,
      use_git_branch = true,
      allowed_dirs = {
        "~/.config",
        "~/Work",
      }
    })

  end,
}
