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

# Fuzzy navigate
alias repos = cd (res_or_pwd (ein tool find $env.REPOS_DIR | fzf | str trim))
alias cdd = cd (res_or_pwd (ls | where type == dir | each { |it| $it.name } | nufzf))

# Change directory to the path OR, if the path is empty, stay.
def res_or_pwd [res] {
    if ($res | is-empty) { pwd | str trim } else { $res }
}

# Edit the Neovim configuration directory. Windows only.
def "conf nvim edit" [] {
    if (false == (windows?)) { echo "This is only supported on Windows!"; } else {
        cd $"($env.LOCALAPPDATA)/nvim"; eval $env.EDITOR;
    }
}

# Run PackerSync in headless nvim, waiting until install completes.
def "conf nvim sync" [] {
    nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"
}

# Switch to the nixos configuration and enter Neovim
def "conf nixos edit" [] {
    if (nixos?) { cd "~/.nixos"; eval $env.EDITOR } else { echo "Command only supported on NixOS" }
}

module dotnet {
    # Runs `dotnet test`, filtering out end-to-end tests.
    export def "dotnet unit" [] { dotnet test --filter TestCategory!=E2ETests }

    # Runs `dotnet test`, with a filter matching only end-to-end tests.
    export def "dotnet e2e" [] { dotnet test --filter TestCategory=E2ETests }

    # Runs `dotnet format` with warn level `info`.
    export def "dotnet fmt" [] { dotnet format -w info }
}

# A Nushell-compatible fzf wrapper
def nufzf [] {
	# fzf expects a newline separated string input,
	# and returns a newline-terminated result.
	str collect (char newline) | fzf --height=40% | str trim | not empty
}

# Skip values that are empty
def "not empty" [] {
	each { |it| if ($it | is-empty) { } else { $it } }
}

use ./nu_scripts/custom-completions/git/git-completions.nu *;
use ./nu_scripts/custom-completions/npm/npm-completions.nu *;