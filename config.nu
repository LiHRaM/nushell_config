# Execute an arbitrary string as Nushell input
def eval [input: string] {
    nu -c $input
}

# Whether the current system is Windows
def windows? [] {
    (sys).host.name == "Windows"
}

# Whether the current system is 
def nixos? [] {
    (sys).host.name == "NixOS"
}

let-env REPOS_DIR = (if (windows?) { 'C:\git' } else { '~/git' | path expand })

# Kubernetes
# alias awp = let-env AWS_PROFILE = (open --raw ~/.aws/config | lines | parse "[profile {profile}]" | get profile | nufzf)
# alias awc = let-env AWS_PROFILE = (open --raw ~/.aws/credentials | lines | parse "[{profile}]" | get profile | nufzf)
# alias kbp = do { kubectl config use-context (kubectl config get-contexts --no-headers | lines | parse -r "[\*]?\s*(?P<Context>\S*).*" | get Context | nufzf) }

alias vim = nvim

# Change directory to the path OR, if the path is empty, stay.
def res_or_pwd [res] {
    if ($res | is-empty) { pwd | str trim } else { $res }
}

# Fuzzy navigate
alias repos = cd (res_or_pwd (ein tool find $env.REPOS_DIR | fzf | str trim))
alias cdd = cd (res_or_pwd (ls | where type == dir | each { |it| $it.name } | nufzf))


# A Nushell-compatible fzf wrapper
def nufzf [] {
	# fzf expects a newline separated string input,
	# and returns a newline-terminated result.
	str join (char newline) | fzf --height=40% | str trim | not empty
}

# Skip values that are empty
def "not empty" [] {
	each { |it| if ($it | is-empty) { } else { $it } }
}

