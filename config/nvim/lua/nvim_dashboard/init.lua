vim.g.dashboard_custom_header = {
'  ______________________________    _____   _______     ________ ________ __________  ____   ____.___    _____   ',
' /   _____/\\__    ___/\\______   \\  /  |  |  \\      \\   /  _____/ \\_____  \\\\______   \\ \\   \\ /   /|   |  /     \\  ',
' \\_____  \\   |    |    |       _/ /   |  |_ /   |   \\ /   \\  ___   _(__  < |       _/  \\   Y   / |   | /  \\ /  \\ ',
' /        \\  |    |    |    |   \\/    ^   //    |    \\\\    \\_\\  \\ /       \\|    |   \\   \\     /  |   |/    Y    \\',
'/_______  /  |____|    |____|_  /\\____   | \\____|__  / \\______  //______  /|____|_  /    \\___/   |___|\\____|__  /',
'        \\/                    \\/      |__|         \\/         \\/        \\/        \\/                          \\/ '
}


vim.g.dashboard_default_executive = 'fzf'

--[[vim.g.dashboard_custom_section = {
    a = {description = {'  Find File          '}, command = 'Telescope find_files'},
    b = {description = {'  Recently Used Files'}, command = 'Telescope oldfiles'},
    c = {description = {'  Load Last Session  '}, command = 'SessionLoad'},
    d = {description = {'  Find Word          '}, command = 'Telescope live_grep'},
    e = {description = {'  Settings           '}, command = ':e ~/.config/nvim/lv-settings.lua'}
}]]--

-- vim.g.dashboard_session_directory = '~/.cache/nvim/session'
vim.g.dashboard_custom_footer = {'Never Think Stop Never Stop Think'}
vim.api.nvim_command('nnoremap <F6> :Dashboard<CR>')
