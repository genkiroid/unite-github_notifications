let s:save_cpo = &cpo
set cpo&vim

execute 'source' expand("<sfile>:h") . "/github_notifications_common.vim"

let s:github_source = { 'name': 'github_notifications' }
let s:github_notifications = []

function! unite#sources#github_notifications#open_url(url, comment_url)
  call unite#sources#github_notifications_common#open_url(a:url, a:comment_url)
endfunction

function! s:get_github_notifications()
  let res = webapi#http#get("https://api.github.com/notifications", '', { "Authorization": "token " . g:github_notifications['github_token'] })
  let notifications = json_decode(res.content)
  for notification in notifications
    call add(s:github_notifications, [notification.subject.title, notification.subject.url, notification.subject.latest_comment_url])
  endfor
endfunction

function! s:github_source.gather_candidates(args, context)
  let s:github_notifications = []
  call s:get_github_notifications()
  return map(copy(s:github_notifications), '{
    \ "word":v:val[0],
    \ "source":"github_notifications",
    \ "kind":"command",
    \ "action__command":"call unite#sources#github_notifications#open_url(''".v:val[1]."'', ''".v:val[2]."'')",
    \ }')
endfunction

function! unite#sources#github_notifications#define()
  return s:github_source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
