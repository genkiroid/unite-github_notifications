let s:save_cpo = &cpo
set cpo&vim

execute 'source' expand("<sfile>:h") . "/github_notifications_common.vim"

let s:ghe_source = { 'name': 'ghe_notifications' }
let s:ghe_notifications = []

function! unite#sources#ghe_notifications#open_url(url, comment_url)
  call unite#sources#github_notifications_common#open_url(a:url, a:comment_url)
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
