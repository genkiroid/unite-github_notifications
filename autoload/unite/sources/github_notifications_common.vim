let s:setting_file = expand(get(g:, 'github_notifications_file', '~/.github_notifications'))
execute 'source' s:setting_file
let s:wsl = get(g:, 'unite_github_notifications_wsl', 0)
let s:wsl_open_cmd = get(g:, 'unite_github_notifications_wsl_open_cmd', "/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe")

function! unite#sources#github_notifications_common#open_url(url, comment_url)
  let url = substitute(a:url, "/api.github.com/repos", "/github.com", "")
  let url = substitute(url, "/api/v3/repos", "", "")
  let url = substitute(url, "/pulls/", "/pull/", "")
  let url_parts = split(a:comment_url, '/')
  let comment_id = url_parts[-1]
  if !empty(comment_id)
    let url = url . '#issuecomment-' . comment_id
  endif
  if has('win32') || has('win64')
    execute '!start rundll32.exe url.dll,FileProtocolHandler ' . fnameescape(url)
  elseif has('mac')
    call system("open '" . url . "'")
  elseif s:wsl
    call system("'" . s:wsl_open_cmd . "' '" . url . "'")
  else
    call system("chrome '" . url . "'")
  endif
endfunction

function! unite#sources#github_notifications_common#define()
  return {}
endfunction
