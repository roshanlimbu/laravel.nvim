-- stylua: ignore start
-- luacheck: globals vim
-- stylua: ignore start
-- luacheck: globals vim
local M = {}

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function file_exists_and_executable(path)
  return vim.fn.filereadable(path) == 1 and vim.fn.executable(path) == 1
end


local function parse_php_version_from_composer(path)
  local ok, json = pcall(function()
    local lines = vim.fn.readfile(path)
    return vim.fn.json_decode(table.concat(lines, "\n"))
  end)
  if not ok or not json or not json.require or not json.require["php"] then
    return nil
  end
  local version = json.require["php"]
  -- version could be ">=8.0", "^8.1", etc. Extract major.minor
  local major, minor = version:match("(%d+)%.(%d+)")
  if major and minor then
    return major .. "." .. minor
  end
  return nil
end

local function get_php_version(bin)
  -- Use double quotes and proper escaping for PHP command
  local cmd = bin .. ' -r "echo PHP_MAJOR_VERSION . \'.\' . PHP_MINOR_VERSION;" 2>/dev/null'
  local handle = io.popen(cmd)
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result then
      result = result:match("%d+%.%d+")
      return result
    end
  end
  return nil
end


function M.get_php_bin()
  -- 1. .nvim-php-bin file
  local file = vim.fn.getcwd() .. "/.nvim-php-bin"
  if vim.fn.filereadable(file) == 1 then
    local bin = trim(vim.fn.readfile(file)[1] or "")
    if #bin > 0 then
      return bin
    end
  end

  -- 2. Environment variable
  local env_bin = vim.env.LARAVEL_NVIM_PHP_BIN
  if env_bin and #env_bin > 0 then
    return env_bin
  end

  -- 3. composer.json PHP version
  local composer = vim.fn.getcwd() .. "/composer.json"
  local required_version = nil
  if vim.fn.filereadable(composer) == 1 then
    required_version = parse_php_version_from_composer(composer)
  end

  local candidates = {}
  -- Homebrew versioned path: /opt/homebrew/opt/php@X.Y/bin/php
  if required_version then
    local major, minor = required_version:match("(%d+)%.(%d+)")
    if major and minor then
      -- For older PHP versions (like 7.3), also try newer compatible versions
      local versions_to_try = { required_version }
      
      -- If required version is 7.3, also try 8.0, 8.1, etc.
      if tonumber(major) == 7 then
        table.insert(versions_to_try, "8.0")
        table.insert(versions_to_try, "8.1")
        table.insert(versions_to_try, "8.2")
      end
      
      for _, version in ipairs(versions_to_try) do
        local v_major, v_minor = version:match("(%d+)%.(%d+)")
        if v_major and v_minor then
          local brew_opt_path = string.format("/opt/homebrew/opt/php@%s.%s/bin/php", v_major, v_minor)
          if vim.fn.executable(brew_opt_path) == 1 then
            table.insert(candidates, brew_opt_path)
          end
          table.insert(candidates, "/opt/homebrew/bin/php" .. v_major .. v_minor)
        end
      end
    end
    table.insert(candidates, "/opt/homebrew/bin/php")
  end
  -- ./vendor/bin/php
  table.insert(candidates, vim.fn.getcwd() .. "/vendor/bin/php")
  -- system php
  table.insert(candidates, "php")

  -- 4. Find a candidate that matches required version
  if required_version then
    for _, bin in ipairs(candidates) do
      if vim.fn.executable(bin) == 1 then
        local ver = get_php_version(bin)
        if ver == required_version then
          return bin
        end
      end
    end
  end

  -- 5. Fallback: first available candidate
  for _, bin in ipairs(candidates) do
    if vim.fn.executable(bin) == 1 then
      return bin
    end
  end

  -- 6. Last resort
  return "php"
end

return M
-- stylua: ignore end
-- stylua: ignore end
