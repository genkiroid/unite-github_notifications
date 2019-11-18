## Usage

Prepare file named `~/.github_notifications`.

```
let g:github_notifications = {
  \ 'github_token': 'Your Github access token',
  \ 'ghe_domain': 'Your GHE host domain',
  \ 'ghe_token':  'Your GHE access token'
\}
```

Source names are as follows.

```
:Unite github_notifications
```

```
:Unite ghe_notifications
```

When using vim on wsl, set a flag on as follows. And set the command that invoke browser, if you need.

```
# Default is 0
let g:unite_github_notifications_wsl = 1

# Default is "/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
let g:unite_github_notifications_wsl = "/path/to/browser_bin"
```
