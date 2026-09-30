-- Useful multicursor mappings
-- See also https://www.reddit.com/r/neovim/comments/1w63ltg/just_migrated_to_multicursor/

vim.keymap.set("n", { "<Esc>", "<M-i>" }, function()
	local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")
	vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
end, { noremap = true, desc = "Clear all multicursors" })

--- Place a cursor and then perform a motion
--- @param opts {mapping: string, movement: string}
local add_cursor_and_move = function(opts)
	local lopts = opts or {}
	vim.api.nvim_feedkeys("2q=", "n", false) -- disable follow-mode, so a new cursor can be placed - like Q
	vim.api.nvim_mcursor(0, vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_feedkeys(lopts.movement, "n", false)
	if vim.v.count1 > 1 then
		vim.api.nvim_feedkeys(
			vim.api.nvim_replace_termcodes((vim.v.count1 - 1) .. lopts.mapping, true, false, true),
			"m",
			false
		)
	end
end

vim.keymap.set("n", "<M-j>", function()
	add_cursor_and_move({ mapping = "<M-j>", movement = "j" })
end, { noremap = true, desc = "Place cursor and move down" })

vim.keymap.set("n", "<M-k>", function()
	add_cursor_and_move({ mapping = "<M-k>", movement = "k" })
end, { noremap = true, desc = "Place a cursor and move up" })

--- Place a cursor and then perform a motion
--- @param opts? {visual_mode?: boolean}
local select_all = function(opts)
	local lopts = opts or {}
	if lopts.visual_mode then
		local selection = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
		vim.fn.setreg("/", "\\V" .. table.concat(selection, "\\n"))
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v`<mx", true, false, true), "n", false)
	else
		vim.api.nvim_feedkeys("wbmx", "n", false) -- move to the beginning of the word and place a cursor
		vim.fn.setreg("/", "\\V\\<" .. vim.fn.expand("<cword>") .. "\\>") -- set search pattern to the current word
	end
	vim.schedule(function()
		-- local pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_feedkeys("Val1Q`x", "n", false)
		-- FIXME: Somehow setting the cursor doesn't work - I use the x-mark as a workaound instead
		-- vim.api.nvim_win_set_cursor(0, pos) -- place cursor back in its original position before placing cursors on the whole document
	end)
end

vim.keymap.set("n", "<M-a>", function()
	select_all()
end, { noremap = true, desc = "Place cursor at all occurances of the word under the cursor" })

vim.keymap.set("x", "<M-a>", function()
	select_all({ visual_mode = true })
end, { noremap = true, desc = "Place cursor at all occurances of selection" })

--- Place a cursor and search/advance to the next entry
--- @param opts {mapping: string, forward_search?: boolean, visual_mode?: boolean, force?: boolean}
local search = function(opts)
	local lopts = opts or {}
	local ns = vim.api.nvim_create_namespace("nvim.multicursor")
	local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1)
	local search_next = lopts.forward_search and "n" or "N"
	if #marks ~= 0 and not lopts.force then
		add_cursor_and_move({ mapping = lopts.mapping, movement = search_next })
		return
	end
	if lopts.visual_mode then
		local selection = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
		vim.fn.setreg("/", "\\V" .. table.concat(selection, "\\n"))
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v`<", true, false, true), "n", false) -- move to the beginning of the word
	else
		vim.api.nvim_feedkeys("wb", "n", false) -- move to the beginning of the word
		vim.fn.setreg("/", "\\V\\<" .. vim.fn.expand("<cword>") .. "\\>") -- set search pattern to the current word
	end
	add_cursor_and_move({ mapping = lopts.mapping, movement = search_next })
end

vim.keymap.set("n", "<M-n>", function()
	search({ mapping = "<M-n>", forward_search = true, visual_mode = false })
end, {
	noremap = true,
	desc = "Set the initial search pattern, place cursor and move to the next occurrence of the word under the cursor",
})

vim.keymap.set("x", "<M-n>", function()
	search({ mapping = "<M-n>", forward_search = true, visual_mode = true })
end, {
	noremap = true,
	desc = "Set the initial search pattern, place cursor and move to the next occurrence of selection",
})

vim.keymap.set("n", "<M-S-n>", function()
	search({ mapping = "<M-S-n>", forward_search = false, visual_mode = false })
end, {
	noremap = true,
	desc = "Set the initial search pattern, place cursor and move to the previous occurrence of the word under the cursor",
})

vim.keymap.set("x", "<M-S-n>", function()
	search({ mapping = "<M-S-n>", forward_search = false, visual_mode = true })
end, {
	noremap = true,
	desc = "Set the initial search pattern, place cursor and move to the previous occurrence of selection ",
})

vim.keymap.set("n", "<M-C-n>", function()
	search({ mapping = "<M-C-n>", forward_search = true, visual_mode = false, force = true })
end, {
	noremap = true,
	desc = "Reset the search pattern, place cursor and advance to the next occurrence of the word under the cursor",
})

vim.keymap.set(
	"x",
	"<M-C-n>",
	function()
		search({ mapping = "<M-C-n>", forward_search = true, visual_mode = true, force = true })
	end,
	{ noremap = true, desc = "Reset the search pattern, place cursor and advance to the next occurrence of selection" }
)

vim.keymap.set("n", "<M-C-S-n>", function()
	search({ mapping = "<M-C-S-n>", forward_search = false, visual_mode = false, force = true })
end, {
	noremap = true,
	desc = "Reset the search pattern, place cursor and advance to the previous occurrence of the word under the cursor",
})

vim.keymap.set("x", "<M-C-S-n>", function()
	search({ mapping = "<M-C-S-n>", forward_search = false, visual_mode = true, force = true })
end, {
	noremap = true,
	desc = "Reset the search pattern, place cursor and advance to the previous occurrence of selection",
})

vim.keymap.set("n", "<M-=>", "q=", { noremap = true, desc = "Toggle multicursor follow mode" })

vim.keymap.set("n", "<M-m>", "[CQ", { noremap = true, desc = "Move back to pervious cursor and remove it" })
