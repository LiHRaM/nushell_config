# Environment variables
load-env {
    # Prompt
    PROMPT_COMMAND: "starship prompt --cmd-duration $env.CMD_DURATION_MS | str trim",
    PROMPT_COMMAND_RIGHT: "",
    PROMPT_INDICATOR: " ",

    # Used by nu commands
    REPOS_DIR: (if (windows?) { "C:\git" } else { "~/git" | path expand }),

    # Useful OS defaults
    LANG: "en_DK",
    LC_ALL: "C.UTF-8",
    LESSCHARSET: "UTF-8",
    EDITOR: "hx",

    # 3rd party programs
    FZF_DEFAULT_OPTS: "--layout=reverse",
    CARGO_TARGET_DIR: ("~/.cargo/target" | path expand),
}

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


def "char envsep" [] {
    if (windows?) { ";" } else { ":" }
}

# Kubernetes
alias awp = let-env AWS_PROFILE = (open --raw ~/.aws/config | lines | parse "[profile {profile}]" | get profile | nufzf)
alias awc = let-env AWS_PROFILE = (open --raw ~/.aws/credentials | lines | parse "[{profile}]" | get profile | nufzf)
alias kbp = do { kubectl config use-context (kubectl config get-contexts --no-headers | lines | parse -r "[\*]?\s*(?P<Context>\S*).*" | get Context | nufzf) }

alias vim = nvim

# Fuzzy navigate
alias repos = cd (res_or_pwd (gix tools find $env.REPOS_DIR | fzf | str trim))
alias cdd = cd (res_or_pwd (ls | where type == dir | each { |it| $it.name } | nufzf))

# Change directory to the path OR, if the path is empty, stay.
def res_or_pwd [res] {
    if ($res | empty?) { pwd | str trim } else { $res }
}


def venv [venv-dir] {
    let venv-abs-dir = ($venv-dir | path expand)
    let venv-name = ($venv-abs-dir | path basename)
    let old-path = ($nu.path | str collect (char envsep))
    let new-path = (venv path $venv-abs-dir)
    let new-env = [[name, value];
                   [VENV_OLD_PATH $old-path]
                   [VIRTUAL_ENV $venv-name]]

    $new-env | append $new-path
}

def "venv path" [venv-dir] {
    let venv-abs-dir = ($venv-dir | path expand)
    if (windows?) { (venv path windows $venv-abs-dir) } else { (venv path unix $venv-abs-dir) }
}

def "venv path unix" [venv-dir] {
    let venv-path = ([$venv-dir "bin"] | path join)
    let new-path = ($nu.path | prepend $venv-path | str collect (char envsep))
    [[name, value]; [PATH $new-path]]
}

def "venv path windows" [venv-dir] {
    # 1. Conda on Windows needs a few additional Path elements
    # 2. The path env var on Windows is called Path (not PATH)
    let venv-path = ([$venv-dir "Scripts"] | path join)
    let new-path = ($nu.path | prepend $venv-path | str collect (char envsep))
    [[name, value]; [Path $new-path]]
}

def "venv deactivate" [] {
    let path-name = if (windows?) { "Path" } else { "PATH" }
    let-env $path-name = $env.VENV_OLD_PATH
    unlet-env VIRTUAL_ENV
    unlet-env VENV_OLD_PATH
}

# Edit the Neovim configuration directory. Windows only.
def "conf nvim edit" [] {
    if ($false == (windows?)) { echo "This is only supported on Windows!"; } else {
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

# Use fzf to checkout to existing branches
def "git co" [] {
	git branch | lines | parse -r "^\s+(?P<Branch>.*)$" | get Branch | nufzf | each { |it| git checkout $it }
}

def "git dd" [] {
	git branch -vl '*/*' | lines | split column " " BranchName Hash Status --collapse-empty | where Status == '[gone]' | each { |it| git branch -D $it.BranchName };
}

# A Nushell-compatible fzf wrapper
def nufzf [] {
	# fzf expects a newline separated string input,
	# and returns a newline-terminated result.
	str collect (char newline) | fzf --height=40% | str trim | not empty
}

# Skip values that are empty
def "not empty" [] {
	each { |it| if ($it | empty?) { } else { $it } }
}


