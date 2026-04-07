require("toggleterm").setup({})

local overseer = require("overseer")

overseer.setup({
  strategy = {
    "toggleterm",
    direction = "vertical",
    -- Dynamically calculate 40% of the editor width
    size = function()
      return math.floor(vim.o.columns * 0.4)
    end,
    quit_on_exit = "never",
  },
})

-- 3. Keymaps
local map = vim.keymap.set

-- Standard Runs
map("n", "<leader>rn", "<cmd>OverseerRun<cr>", { desc = "Run Task" })
map("n", "<leader>rt", "<cmd>OverseerToggle<cr>", { desc = "Overseer Toggle" })

-- Restart Last Task (Your custom logic)
map("n", "<leader>rr", function()
  vim.cmd("write")
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    overseer.run_task()
  else
    overseer.run_action(tasks[1], "restart")
  end
end, { desc = "Restart Last Task" })

-- Just Recipes (Your custom logic)
map("n", "<leader>rj", function()
  overseer.run_task({ name = "just" })
end, { desc = "Just Recipes" })
