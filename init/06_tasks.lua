require("toggletasks").setup({
    debug = false,
    silent = false,  -- don't show "info" messages
    short_paths = true,  -- display relative paths when possible
    search_paths = { '.vscode/toggletasks' },
    scan = {
      global_cwd = true,    -- vim.fn.getcwd(-1, -1)
    },
    tasks = { },  
    toggleterm = {
        start_in_insert=true,
        close_on_exit = false,
        hidden = false,
        -- direction = "float"
        direction = "tab"
    },
    telescope = {
        spawn = {
            open_single = true,  -- auto-open terminal window when spawning a single task
            show_running = false, -- include already running tasks in picker candidates
            mappings = {
                select_float = '<C-f>',
                spawn_smart = '<C-a>',  -- all if no entries selected, else use multi-select
                spawn_all = '<M-a>',    -- all visible entries
                spawn_selected = nil,   -- entries selected via multi-select (default <tab>)
            },
        },
        select = {
            mappings = {
                select_float = '<C-f>',
                open_smart = '<C-a>',
                open_all = '<M-a>',
                open_selected = nil,
                kill_smart = '<C-q>',
                kill_all = '<M-q>',
                kill_selected = nil,
                respawn_smart = '<C-s>',
                respawn_all = '<M-s>',
                respawn_selected = nil,
            },
        },
    },
})
