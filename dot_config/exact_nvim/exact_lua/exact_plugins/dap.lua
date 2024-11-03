return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- DAP UI setup
      dapui.setup()

      -- Keymaps
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
      vim.keymap.set('n', '<leader>df', dap.run_to_cursor)
      vim.keymap.set('n', '<leader>dc', dap.continue)
      vim.keymap.set('n', '<leader>dr', dap.restart)
      vim.keymap.set('n', '<leader>dsi', dap.step_into)
      vim.keymap.set('n', '<leader>dso', dap.step_out)
      vim.keymap.set('n', '<leader>dui', dapui.toggle)
      vim.keymap.set('n', '<leader>dv', function()
        dapui.eval(nil, { enter = true })
      end)

      -- Python setup
      if vim.bo.filetype == 'python' then
        local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
        require('dap-python').setup(path)
      end
    end,
  },
}
