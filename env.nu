source ./hosts.nu

let-env LANG = "en_DK"
let-env LC_ALL = "C.UTF-8"
let-env REPOS_DIR = (if (windows?) { "C:\git" } else { "~/git" | path expand })
let-env FZF_DEFAULT_OPTS = "--layout=reverse"
let-env EDITOR = "nvim"

