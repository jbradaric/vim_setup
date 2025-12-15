local M = {}

local async = require("plenary.async")

-- Configuration
M.config = {
  remote = "origin",
  base_branch = "master",
  draft = false,
}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

-- Output buffer management
local OutputBuffer = {}
OutputBuffer.__index = OutputBuffer

function OutputBuffer:new()
  local obj = {
    bufnr = nil,
    winnr = nil,
  }
  setmetatable(obj, self)
  return obj
end

function OutputBuffer:create()
  self.bufnr = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_option(self.bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(self.bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(self.bufnr, "swapfile", false)
  vim.api.nvim_buf_set_option(self.bufnr, "filetype", "gitlab-mr")
  vim.api.nvim_buf_set_name(self.bufnr, "GitLab MR Cherry-pick")

  vim.cmd("botright split")
  self.winnr = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(self.winnr, self.bufnr)
  vim.api.nvim_win_set_height(self.winnr, 15)

  vim.api.nvim_win_set_option(self.winnr, "wrap", false)
  vim.api.nvim_win_set_option(self.winnr, "number", false)
  vim.api.nvim_win_set_option(self.winnr, "relativenumber", false)

  -- Setup syntax highlighting
  self:setup_highlights()

  vim.keymap.set("n", "q", function()
    self:close()
  end, { buffer = self.bufnr, silent = true })

  return self
end

function OutputBuffer:setup_highlights()
  -- Define highlight groups
  vim.api.nvim_set_hl(0, "GitLabMrTitle", { fg = "#81A1C1", bold = true })
  vim.api.nvim_set_hl(0, "GitLabMrSection", { fg = "#88C0D0", bold = true })
  vim.api.nvim_set_hl(0, "GitLabMrSuccess", { fg = "#A3BE8C", bold = true })
  vim.api.nvim_set_hl(0, "GitLabMrError", { fg = "#BF616A", bold = true })
  vim.api.nvim_set_hl(0, "GitLabMrWarning", { fg = "#EBCB8B", bold = true })
  vim.api.nvim_set_hl(0, "GitLabMrCommand", { fg = "#B48EAD", italic = true })
  vim.api.nvim_set_hl(0, "GitLabMrInfo", { fg = "#D8DEE9" })
  vim.api.nvim_set_hl(0, "GitLabMrCommit", { fg = "#8FBCBB" })
  vim.api.nvim_set_hl(0, "GitLabMrBorder", { fg = "#4C566A" })

  -- Apply syntax patterns
  vim.cmd([[
        syntax match GitLabMrTitle /^╔.*╗$/
        syntax match GitLabMrTitle /^║.*║$/
        syntax match GitLabMrTitle /^╚.*╝$/
        syntax match GitLabMrBorder /^[─═│║╔╗╚╝┌┐└┘├┤┬┴┼]/
        syntax match GitLabMrSection /^▶.*$/
        syntax match GitLabMrSuccess /^✓.*$/
        syntax match GitLabMrError /^✗.*$/
        syntax match GitLabMrWarning /^⚠.*$/
        syntax match GitLabMrCommand /^\$ git.*$/
        syntax match GitLabMrCommit /\<[0-9a-f]\{7,40\}\>/
    ]])
end

function OutputBuffer:append(lines)
  if not self.bufnr or not vim.api.nvim_buf_is_valid(self.bufnr) then
    return
  end

  if type(lines) == "string" then
    lines = vim.split(lines, "\n")
  end

  local line_count = vim.api.nvim_buf_line_count(self.bufnr)
  vim.api.nvim_buf_set_lines(self.bufnr, line_count, line_count, false, lines)

  if self.winnr and vim.api.nvim_win_is_valid(self.winnr) then
    local new_line_count = vim.api.nvim_buf_line_count(self.bufnr)
    vim.api.nvim_win_set_cursor(self.winnr, { new_line_count, 0 })
  end
end

function OutputBuffer:append_title(text)
  local width = 70
  local padding = math.floor((width - #text - 2) / 2)
  local line = "║ " .. string.rep(" ", padding) .. text .. string.rep(" ", width - padding - #text - 3) .. " ║"
  self:append({
    "╔" .. string.rep("═", width) .. "╗",
    line,
    "╚" .. string.rep("═", width) .. "╝",
  })
end

function OutputBuffer:append_section(text)
  self:append("▶ " .. text)
end

function OutputBuffer:append_command(cmd)
  self:append("  $ git " .. table.concat(cmd, " "))
end

function OutputBuffer:append_success(msg)
  self:append("  ✓ " .. msg)
end

function OutputBuffer:append_error(msg)
  self:append("  ✗ " .. msg)
end

function OutputBuffer:append_warning(msg)
  self:append("  ⚠ " .. msg)
end

function OutputBuffer:append_info(msg, indent)
  indent = indent or 2
  self:append(string.rep(" ", indent) .. msg)
end

function OutputBuffer:append_separator()
  self:append("")
end

function OutputBuffer:append_divider()
  self:append("  " .. string.rep("─", 68))
end

function OutputBuffer:close()
  if self.winnr and vim.api.nvim_win_is_valid(self.winnr) then
    vim.api.nvim_win_close(self.winnr, true)
  end
end

-- Async git command using plenary
local git = async.wrap(function(args, output_buf, callback)
  if output_buf then
    output_buf:append_command(args)
  end

  vim.system(
    vim.list_extend({ "git" }, args),
    { text = true },
    function(result)
      vim.schedule(function()
        if output_buf and result.stdout and #vim.trim(result.stdout) > 0 then
          for _, line in ipairs(vim.split(result.stdout, "\n")) do
            if #vim.trim(line) > 0 then
              output_buf:append_info(line, 4)
            end
          end
        end
        if output_buf and result.stderr and #vim.trim(result.stderr) > 0 then
          for _, line in ipairs(vim.split(result.stderr, "\n")) do
            if #vim.trim(line) > 0 then
              output_buf:append_info(line, 4)
            end
          end
        end
        if output_buf then
          output_buf:append_separator()
        end

        callback(result.code == 0, result)
      end)
    end
  )
end, 3)

-- Async get commit info
local get_commit_info = async.wrap(function(commit, output_buf, callback)
  vim.system(
    { "git", "rev-parse", commit },
    { text = true },
    function(result1)
      if result1.code ~= 0 then
        vim.schedule(function() callback(nil) end)
        return
      end

      local hash = vim.trim(result1.stdout)

      vim.system(
        { "git", "log", "-1", "--format=%s", commit },
        { text = true },
        function(result2)
          vim.schedule(function()
            if result2.code ~= 0 then
              callback(nil)
              return
            end

            local subject = vim.trim(result2.stdout)
            callback({
              hash = hash,
              subject = subject,
            })
          end)
        end
      )
    end
  )
end, 3)

local function create_temp_branch(base_commit)
  local timestamp = os.time()
  local short_hash = base_commit:sub(1, 7)
  return string.format("mr/cherry-pick-%s-%d", short_hash, timestamp)
end

-- Async confirm using plenary
local confirm = async.wrap(function(prompt, callback)
  vim.schedule(function()
    local response = vim.fn.input(prompt .. " (y/n) ")
    print("")
    callback(response:lower() == "y")
  end)
end, 2)

local cleanup_branch = async.void(function(current_branch, temp_branch, output)
  git({ "cherry-pick", "--abort" }, output)
  git({ "checkout", current_branch }, output)
  git({ "branch", "-D", temp_branch }, output)
end)

-- Main async function
local create_merge_request_async = async.void(function(commits, opts)
  opts = opts or {}
  local remote = opts.remote or M.config.remote
  local base_branch = opts.base_branch or M.config.base_branch
  local mr_title = opts.mr_title
  local draft = opts.draft or M.config.draft

  -- Create output buffer
  local output = OutputBuffer:new():create()
  output:append_title("GitLab MR Cherry-pick")
  output:append_separator()

  -- Verify we're in a git repository
  output:append_section("Verifying git repository")
  local success = git({ "rev-parse", "--git-dir" }, output)
  if not success then
    output:append_error("Not in a git repository")
    notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end
  output:append_success("Repository verified")
  output:append_separator()

  -- Get commit infos
  output:append_section("Collecting commit information")
  local commit_infos = {}
  for _, commit in ipairs(commits) do
    local info = get_commit_info(commit, output)
    if not info then
      output:append_error("Invalid commit reference: " .. commit)
      notify("Invalid commit reference: " .. commit, vim.log.levels.ERROR)
      return
    end
    table.insert(commit_infos, info)
  end

  output:append_info("Cherry-picking " .. #commit_infos .. " commit(s):")
  for i, info in ipairs(commit_infos) do
    output:append_info(string.format("%d. %s - %s", i, info.hash:sub(1, 7), info.subject), 4)
  end
  output:append_separator()

  -- Get current branch
  output:append_section("Getting current branch")
  local success2, result = git({ "rev-parse", "--abbrev-ref", "HEAD" }, output)
  if not success2 then
    output:append_error("Failed to get current branch")
    notify("Failed to get current branch", vim.log.levels.ERROR)
    return
  end

  local current_branch = vim.trim(result.stdout)
  output:append_info("Current branch: " .. current_branch)
  output:append_separator()

  -- Create temp branch
  local temp_branch = create_temp_branch(commit_infos[1].hash)
  output:append_section("Creating temporary branch")
  output:append_info("Branch name: " .. temp_branch)
  output:append_separator()

  -- Fetch base branch
  output:append_section("Fetching base branch")
  success = git({ "fetch", remote, base_branch }, output)
  if not success then
    output:append_error("Failed to fetch " .. remote .. "/" .. base_branch)
    notify("Failed to fetch", vim.log.levels.ERROR)
    return
  end
  output:append_success("Fetch complete")
  output:append_separator()

  -- Create new branch
  output:append_section("Creating branch from " .. remote .. "/" .. base_branch)
  success = git({ "checkout", "--no-track", "-b", temp_branch, remote .. "/" .. base_branch }, output)
  if not success then
    output:append_error("Failed to create branch")
    notify("Failed to create branch", vim.log.levels.ERROR)
    return
  end
  output:append_success("Branch created")
  output:append_separator()

  -- Cherry-pick commits
  output:append_section("Cherry-picking commits")
  for i, info in ipairs(commit_infos) do
    output:append_info(string.format("[%d/%d] %s", i, #commit_infos, info.hash:sub(1, 7)))
    success = git({ "cherry-pick", info.hash }, output)
    if not success then
      output:append_error("Cherry-pick failed")
      notify("Cherry-pick failed", vim.log.levels.ERROR)
      cleanup_branch(current_branch, temp_branch, output)
      return
    end
    output:append_success("Cherry-picked " .. info.hash:sub(1, 7))
  end
  output:append_success("All cherry-picks successful")
  output:append_separator()

  -- Push to remote and create MR in one command
  local final_mr_title = mr_title or commit_infos[1].subject
  output:append_section("Pushing and creating merge request")
  output:append_info("Target: " .. base_branch)
  output:append_info("Title: " .. final_mr_title)
  output:append_separator()

  local push_opts = {
    "push",
    "-o", "merge_request.create",
    "-o", "merge_request.title=" .. final_mr_title,
    "-o", "merge_request.target=" .. base_branch,
    "-o", "merge_request.remove_source_branch",
  }

  if draft then
    table.insert(push_opts, "-o")
    table.insert(push_opts, "merge_request.draft")
    output:append_info("Draft: yes")
  end

  table.insert(push_opts, remote)
  table.insert(push_opts, temp_branch .. ":" .. temp_branch)

  success = git(push_opts, output)
  if not success then
    output:append_error("Failed to push to remote")
    notify("Failed to push", vim.log.levels.ERROR)
    cleanup_branch(current_branch, temp_branch, output)
    return
  end

  output:append_success("Pushed to remote")
  output:append_success("Merge request created!")
  output:append_divider()
  output:append_info("📋 MR Details:", 2)
  output:append_info("  Branch: " .. temp_branch, 2)
  output:append_info("  Title:  " .. final_mr_title, 2)
  output:append_info("  Target: " .. base_branch, 2)
  output:append_info("  Auto-delete: enabled", 2)
  output:append_divider()
  output:append_separator()
  notify("✓ Merge request created successfully!", vim.log.levels.INFO)

  -- Checkout back to original branch
  output:append_section("Returning to original branch")
  git({ "checkout", current_branch }, output)
  output:append_success("Checked out to " .. current_branch)
  output:append_separator()

  -- Check for uncommitted changes before proceeding with commit removal
  -- We only care about tracked files (staged or unstaged), not untracked files
  output:append_section("Checking for uncommitted changes")
  local status_result = git({ "status", "--porcelain" }, nil)

  local has_uncommitted = false
  if status_result and #vim.trim(status_result.stdout) > 0 then
    -- Check each line - ignore lines starting with '??' (untracked files)
    for _, line in ipairs(vim.split(status_result.stdout, "\n")) do
      if #vim.trim(line) > 0 and not line:match("^%?%?") then
        has_uncommitted = true
        break
      end
    end
  end

  if has_uncommitted then
    output:append_warning("Uncommitted changes detected")
    output:append_info("Cannot safely remove commits with uncommitted changes", 2)
    output:append_info("Please commit or stash your changes first", 2)
    output:append_separator()
    output:append_divider()
    output:append_info("✨ MR created! Press 'q' to close this window", 2)
    output:append_divider()
    notify("⚠ Skipped commit removal - uncommitted changes detected", vim.log.levels.WARN)
    return
  end

  output:append_success("No uncommitted changes")
  output:append_separator()

  -- Confirm and remove commits
  local confirmed = confirm("Ready to remove " .. #commits .. " commit(s) from " .. current_branch .. "?")
  if not confirmed then
    output:append_warning("Skipped commit removal")
    output:append_separator()
    output:append_divider()
    output:append_info("✨ All done! Press 'q' to close this window", 2)
    output:append_divider()
    notify("Skipped commit removal")
    return
  end

  -- Remove commits
  output:append_section("Removing commits from " .. current_branch)

  -- Check if we're removing commits at HEAD
  local head_hash_result = git({ "rev-parse", "HEAD" }, nil)
  local head_hash = head_hash_result and vim.trim(head_hash_result.stdout) or ""
  local last_commit_is_head = (commit_infos[#commit_infos].hash == head_hash)

  if last_commit_is_head then
    -- Commits are at HEAD, use reset (simpler and works for single commit)
    output:append_info("Commits are at HEAD, using reset")
    local reset_target = commit_infos[1].hash .. "^"
    output:append_info("Resetting to " .. reset_target:sub(1, 7))
    output:append_separator()

    success = git({ "reset", "--hard", reset_target }, output)

    if success then
      output:append_success("Commits removed from " .. current_branch)
      notify("✓ Commits removed from " .. current_branch, vim.log.levels.INFO)
    else
      output:append_error("Failed to remove commits")
      output:append_warning("You may need to manually remove them")
      notify("Failed to remove commits", vim.log.levels.ERROR)
    end
  else
    -- Commits are in the middle of history, use interactive rebase
    output:append_info("Commits are in history, using interactive rebase")

    -- Create a list of short hashes to drop
    local hashes_to_drop = {}
    for _, info in ipairs(commit_infos) do
      table.insert(hashes_to_drop, info.hash:sub(1, 7))
    end

    -- Create a temporary script that modifies the rebase todo list
    local script_path = vim.fn.tempname()
    local grep_pattern = table.concat(hashes_to_drop, "|")
    local script_content = string.format([[#!/bin/bash
# Remove selected commits from the rebase todo list
grep -v -E '%s' "$1" > "$1.tmp" && mv "$1.tmp" "$1"
]], grep_pattern)

    local script_file = io.open(script_path, "w")
    if script_file then
      script_file:write(script_content)
      script_file:close()
      vim.fn.system("chmod +x " .. script_path)
    end

    -- Run interactive rebase with our custom editor
    local rebase_base = commit_infos[1].hash .. "^"
    local env = {
      GIT_SEQUENCE_EDITOR = script_path,
    }

    output:append_info("Rebasing from " .. rebase_base:sub(1, 7))
    output:append_info("Dropping commits: " .. table.concat(hashes_to_drop, ", "))
    output:append_separator()

    -- Use vim.system with custom environment
    local rebase_success = async.wrap(function(callback)
      vim.system(
        { "git", "rebase", "-i", rebase_base },
        {
          text = true,
          env = env,
        },
        function(result)
          vim.schedule(function()
            -- Clean up temp script
            vim.fn.delete(script_path)

            if output then
              if result.stdout and #vim.trim(result.stdout) > 0 then
                for _, line in ipairs(vim.split(result.stdout, "\n")) do
                  if #vim.trim(line) > 0 then
                    output:append_info(line, 4)
                  end
                end
              end
              if result.stderr and #vim.trim(result.stderr) > 0 then
                for _, line in ipairs(vim.split(result.stderr, "\n")) do
                  if #vim.trim(line) > 0 then
                    output:append_info(line, 4)
                  end
                end
              end
              output:append_separator()
            end

            callback(result.code == 0, result)
          end)
        end
      )
    end, 1)

    success = rebase_success()

    if success then
      output:append_success("Commits removed from " .. current_branch)
      notify("✓ Commits removed from " .. current_branch, vim.log.levels.INFO)
    else
      output:append_error("Failed to remove commits")
      output:append_warning("You may need to manually remove them or resolve conflicts")
      notify("Failed to remove commits", vim.log.levels.ERROR)
    end
  end

  output:append_separator()
  output:append_divider()
  output:append_info("✨ All done! Press 'q' to close this window", 2)
  output:append_divider()
end)

function M.create_merge_request(commits, opts)
  create_merge_request_async(commits, opts)
end

local function extract_commit_hash(line)
  return line:match("^(%w+)")
end

local function extract_commit_subject(line)
  -- Neogit format: "hash  [branch_name] subject" or "hash  subject"
  -- Branch names can be: "master", "origin/master", or absent

  -- Remove the hash and initial whitespace
  local rest = line:match("^%w+%s+(.*)$")
  if not rest then
    return ""
  end

  -- Check if it starts with a branch name pattern (word or origin/word)
  -- Branch names are typically: word, origin/word, or similar patterns
  -- The subject usually starts with a capital letter or special char

  -- Try to match: optional_branch_name followed by the subject
  -- If first word is all lowercase/contains '/', it's likely a branch name
  local maybe_branch, subject = rest:match("^(%S+)%s+(.+)$")

  if maybe_branch and subject then
    -- Check if maybe_branch looks like a branch name
    -- (lowercase, contains /, or common branch names)
    if maybe_branch:match("^[a-z]") or
        maybe_branch:match("/") or
        maybe_branch == "HEAD" then
      return subject
    end
  end

  -- No branch name detected, everything is the subject
  return rest
end

function M.create_mr_from_selection()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  local commits = {}
  local first_subject = nil

  for line_num = start_line, end_line do
    local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
    local commit = extract_commit_hash(line)
    if commit then
      table.insert(commits, commit)
      if not first_subject then
        first_subject = extract_commit_subject(line)
      end
    end
  end

  if #commits == 0 then
    notify("Could not extract any commit hashes from selection", vim.log.levels.ERROR)
    return
  end

  if #commits > 1 then
    vim.ui.input({
      prompt = "MR Title: ",
      default = first_subject or "",
    }, function(input)
      if input ~= nil then
        notify("Creating MR for " .. #commits .. " commit(s)")
        M.create_merge_request(commits, { mr_title = input })
      else
        notify("Cancelled")
      end
    end)
  else
    notify("Creating MR for commit: " .. commits[1])
    M.create_merge_request(commits)
  end
end

function M.create_mr_from_current_line()
  local line = vim.api.nvim_get_current_line()
  local commit = extract_commit_hash(line)

  if not commit or #commit == 0 then
    notify("Could not extract commit hash from current line", vim.log.levels.ERROR)
    return
  end

  notify("Creating MR for commit: " .. commit)
  M.create_merge_request({ commit })
end

function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.config, opts)

  vim.api.nvim_create_user_command(
    "GitLabMrCherryPick",
    M.create_mr_from_current_line,
    { desc = "Create GitLab MR from commit on current line" }
  )

  vim.api.nvim_create_user_command(
    "GitLabMrCherryPickSelection",
    M.create_mr_from_selection,
    { range = true, desc = "Create GitLab MR from selected commits" }
  )
end

return M
