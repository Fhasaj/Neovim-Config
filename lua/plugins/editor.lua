-- Window management and general editing niceties.
return {
  -- Resizing and moving windows around.
  --
  --   <C-h/j/k/l>          move focus (also hops between tmux panes)
  --   <A-Left/Down/Up/Right> resize the current window
  --   <A-S-h/j/k/l>        swap this window with the neighbour
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {
      -- Don't resize past the point where a window becomes unusable.
      default_amount = 3,
      at_edge = "stop",
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
    },
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Focus window left",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Focus window down",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Focus window up",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Focus window right",
      },

      {
        "<A-Left>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "Resize window left",
      },
      {
        "<A-Down>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "Resize window down",
      },
      {
        "<A-Up>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "Resize window up",
      },
      {
        "<A-Right>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "Resize window right",
      },

      {
        "<A-S-h>",
        function()
          require("smart-splits").swap_buf_left()
        end,
        desc = "Swap window left",
      },
      {
        "<A-S-j>",
        function()
          require("smart-splits").swap_buf_down()
        end,
        desc = "Swap window down",
      },
      {
        "<A-S-k>",
        function()
          require("smart-splits").swap_buf_up()
        end,
        desc = "Swap window up",
      },
      {
        "<A-S-l>",
        function()
          require("smart-splits").swap_buf_right()
        end,
        desc = "Swap window right",
      },
    },
  },

  -- Move the current line/selection with Alt+Up/Down, as in VS Code.
  -- LazyVim binds <A-j>/<A-k> for this; these add the arrow-key equivalents.
  {
    "LazyVim/LazyVim",
    keys = {
      { "<A-S-Down>", "<cmd>m .+1<cr>==", desc = "Move line down" },
      { "<A-S-Up>", "<cmd>m .-2<cr>==", desc = "Move line up" },
      { "<A-S-Down>", ":m '>+1<cr>gv=gv", mode = "v", desc = "Move selection down" },
      { "<A-S-Up>", ":m '<-2<cr>gv=gv", mode = "v", desc = "Move selection up" },
    },
  },

  -- Multi-cursor: Ctrl+N adds the next occurrence of the word under the cursor,
  -- the closest thing to VS Code's Ctrl+D.
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select All"] = "<C-S-n>",
      }
      vim.g.VM_silent_exit = 1
    end,
  },
}
