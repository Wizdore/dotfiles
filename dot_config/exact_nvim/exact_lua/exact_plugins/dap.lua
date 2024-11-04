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

      -- Debug mode state
      local debug_mode = false

      -- DAP UI setup with customizable layouts
      dapui.setup {
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.25 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'stacks', size = 0.25 },
              { id = 'watches', size = 0.25 },
            },
            size = 40,
            position = 'left',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 10,
            position = 'bottom',
          },
        },
      }

      local function enter_debug_mode()
        debug_mode = true
        vim.g.debug_mode_active = true
        -- Set up a minimal status line with Debug indicator
        -- vim.opt.statusline = '%#Debug# Debug %#StatusLine# %f %m%r%h%w%=%l,%c %P'

        -- Debug mode mappings
        local debug_mappings = {
          -- Mode switching
          ['<Esc>'] = function()
            if vim.fn.getcmdtype() ~= '' or vim.fn.getcmdline() ~= '' then
              return '<Esc>'
            else
              exit_debug_mode()
            end
          end,

          -- Debug control
          ['c'] = dap.continue,
          ['n'] = dap.step_over,
          ['s'] = dap.step_into,
          ['o'] = dap.step_out,
          ['r'] = dap.restart,
          ['f'] = dap.run_to_cursor,

          -- Breakpoints
          ['b'] = dap.toggle_breakpoint,
          ['B'] = function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
          end,

          -- UI Controls
          ['u'] = dapui.toggle,
          ['v'] = function()
            dapui.eval(nil, { enter = true })
          end,

          -- Individual UI element controls
          ['<Space>1'] = function()
            dapui.toggle 'scopes'
          end,
          ['<Space>2'] = function()
            dapui.toggle 'watches'
          end,
          ['<Space>3'] = function()
            dapui.toggle 'stacks'
          end,
          ['<Space>4'] = function()
            dapui.toggle 'breakpoints'
          end,
          ['<Space>5'] = function()
            dapui.toggle 'console'
          end,
          ['<Space>6'] = function()
            dapui.toggle 'repl'
          end,

          -- Layout controls
          ['<Space>l'] = function()
            dapui.toggle 'sidebar'
          end,
          ['<Space>j'] = function()
            dapui.toggle 'tray'
          end,

          -- Quick layouts
          ['1'] = function()
            dapui.setup {
              layouts = {
                {
                  elements = { { id = 'scopes', size = 0.25 } },
                  size = 40,
                  position = 'left',
                },
              },
            }
          end,
          ['2'] = function()
            dapui.setup {
              layouts = {
                {
                  elements = {
                    { id = 'repl', size = 0.5 },
                    { id = 'console', size = 0.5 },
                  },
                  size = 10,
                  position = 'bottom',
                },
              },
            }
          end,
          ['3'] = function()
            dapui.setup {
              layouts = {
                {
                  elements = {
                    { id = 'scopes', size = 0.25 },
                    { id = 'breakpoints', size = 0.25 },
                    { id = 'stacks', size = 0.25 },
                    { id = 'watches', size = 0.25 },
                  },
                  size = 40,
                  position = 'right',
                },
              },
            }
          end,
        }

        -- Apply debug mode mappings
        for key, command in pairs(debug_mappings) do
          vim.keymap.set('n', key, command, { silent = true, buffer = 0 })
        end
      end

      function exit_debug_mode()
        debug_mode = false
        vim.g.debug_mode_active = false
        -- Restore the original statusline
        vim.opt.statusline = ''

        -- Clear debug mode mappings
        local keys = {
          'c',
          'n',
          's',
          'o',
          'r',
          'f',
          'b',
          'B',
          'u',
          'h',
          'v',
          '<Space>1',
          '<Space>2',
          '<Space>3',
          '<Space>4',
          '<Space>5',
          '<Space>6',
          '<Space>l',
          '<Space>j',
          '1',
          '2',
          '3',
          '<Esc>',
        }
        for _, key in ipairs(keys) do
          vim.keymap.del('n', key, { buffer = 0 })
        end
      end

      -- Create debug mode command and mapping
      vim.api.nvim_create_user_command('DebugMode', function()
        if debug_mode then
          exit_debug_mode()
        else
          enter_debug_mode()
        end
      end, {})

      -- Global keymapping to enter debug mode
      vim.keymap.set('n', '<leader>dd', enter_debug_mode, { silent = true, desc = 'Enter debug mode' })

      -- Python setup
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
          local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
          require('dap-python').setup(path)
        end,
      })
    end,
  },
}
