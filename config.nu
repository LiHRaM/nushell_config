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
alias awp = let-env AWS_PROFILE = (open --raw ~/.aws/config | lines | parse "[profile {profile}]" | get profile | nufzf)
alias awc = let-env AWS_PROFILE = (open --raw ~/.aws/credentials | lines | parse "[{profile}]" | get profile | nufzf)
alias kbp = do { kubectl config use-context (kubectl config get-contexts --no-headers | lines | parse -r "[\*]?\s*(?P<Context>\S*).*" | get Context | nufzf) }

alias vim = nvim

# Fuzzy navigate
alias repos = cd (res_or_pwd (ein tools find $env.REPOS_DIR | fzf | str trim))
alias cdd = cd (res_or_pwd (ls | where type == dir | each { |it| $it.name } | nufzf))

# Change directory to the path OR, if the path is empty, stay.
def res_or_pwd [res] {
    if ($res | empty?) { pwd | str trim } else { $res }
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
	each { |it| if ($it | empty?) { } else { $it } }
}

module completions {
    # Custom completions for external commands (those outside of Nushell)
    # Each completions has two parts: the form of the external command, including its flags and parameters
    # and a helper command that knows how to complete values for those flags and parameters
    #
    # This is a simplified version of completions for git branches and git remotes
    def "nu-complete git branches" [] {
      ^git branch | lines | each { |line| $line | str replace '\* ' '' | str trim }
    }
  
    def "nu-complete git remotes" [] {
      ^git remote | lines | each { |line| $line | str trim }
    }
  
    export extern "git checkout" [
      branch?: string@"nu-complete git branches" # name of the branch to checkout
      -b: string                                 # create and checkout a new branch
      -B: string                                 # create/reset and checkout a branch
      -l                                         # create reflog for new branch
      --guess                                    # second guess 'git checkout <no-such-branch>' (default)
      --overlay                                  # use overlay mode (default)
      --quiet(-q)                                # suppress progress reporting
      --recurse-submodules: string               # control recursive updating of submodules
      --progress                                 # force progress reporting
      --merge(-m)                                # perform a 3-way merge with the new branch
      --conflict: string                         # conflict style (merge or diff3)
      --detach(-d)                               # detach HEAD at named commit
      --track(-t)                                # set upstream info for new branch
      --force(-f)                                # force checkout (throw away local modifications)
      --orphan: string                           # new unparented branch
      --overwrite-ignore                         # update ignored files (default)
      --ignore-other-worktrees                   # do not check if another worktree is holding the given ref
      --ours(-2)                                 # checkout our version for unmerged files
      --theirs(-3)                               # checkout their version for unmerged files
      --patch(-p)                                # select hunks interactively
      --ignore-skip-worktree-bits                # do not limit pathspecs to sparse entries only
      --pathspec-from-file: string               # read pathspec from file
    ]
  
    export extern "git push" [
      remote?: string@"nu-complete git remotes", # the name of the remote
      refspec?: string@"nu-complete git branches"# the branch / refspec
      --verbose(-v)                              # be more verbose
      --quiet(-q)                                # be more quiet
      --repo: string                             # repository
      --all                                      # push all refs
      --mirror                                   # mirror all refs
      --delete(-d)                               # delete refs
      --tags                                     # push tags (can't be used with --all or --mirror)
      --dry-run(-n)                              # dry run
      --porcelain                                # machine-readable output
      --force(-f)                                # force updates
      --force-with-lease: string                 # require old value of ref to be at this value
      --recurse-submodules: string               # control recursive pushing of submodules
      --thin                                     # use thin pack
      --receive-pack: string                     # receive pack program
      --exec: string                             # receive pack program
      --set-upstream(-u)                         # set upstream for git pull/status
      --progress                                 # force progress reporting
      --prune                                    # prune locally removed refs
      --no-verify                                # bypass pre-push hook
      --follow-tags                              # push missing but relevant tags
      --signed: string                           # GPG sign the push
      --atomic                                   # request atomic transaction on remote side
      --push-option(-o): string                  # option to transmit
      --ipv4(-4)                                 # use IPv4 addresses only
      --ipv6(-6)                                 # use IPv6 addresses only
    ]
  }
  
  # Get just the extern definitions without the custom completion commands
  use completions *
