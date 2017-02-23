let s:save_cpo = &cpo
set cpo&vim

let s:ghe_source = { 'name': 'ghe_notifications' }
let s:ghe_notifications = []
let s:setting_file = expand(get(g:, 'github_notifications_file', '~/.github_notifications'))
execute 'source' s:setting_file

function! unite#sources#ghe_notifications#open_url(url, comment_url)
  let url = substitute(a:url, "/api/v3/repos", "", "")
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
  else
    call system("chrome '" . url . "'")
  endif
endfunction

function! s:get_ghe_notifications()
  let res = webapi#http#get("https://" . g:github_notifications['ghe_domain']. "/api/v3/notifications", '', { "Authorization": "token " . g:github_notifications['ghe_token'] })
  let notifications = json_decode(res.content)
  for notification in notifications
    call add(s:ghe_notifications, [notification.subject.title, notification.subject.url, notification.subject.latest_comment_url])
  endfor
endfunction

function! s:ghe_source.gather_candidates(args, context)
  let s:ghe_notifications = []
  call s:get_ghe_notifications()
  return map(copy(s:ghe_notifications), '{
    \ "word":v:val[0],
    \ "source":"ghe_notifications",
    \ "kind":"command",
    \ "action__command":"call unite#sources#ghe_notifications#open_url(''".v:val[1]."'', ''".v:val[2]."'')",
    \ }')
endfunction

function! unite#sources#ghe_notifications#define()
  return s:ghe_source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
