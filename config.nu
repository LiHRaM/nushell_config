source ./synq-utils.nu

# Preview Markdown files being changed
def markview [path: string = "."] {
    echo "Edit your files to start previewing"
    watch $path --glob=**/*.md {|op, path|
        clear
        glow $path
    }
}

# Execute an arbitrary string as Nushell input
def eval [input: string] {
    nu -c $input
}

# Whether the current system is Windows
def windows? [] {
    (sys host).name == "Windows"
}

# Whether the current system is 
def nixos? [] {
    (sys host).name == "NixOS"
}

$env.REPOS_DIR = (if (windows?) { 'C:\git' } else { '~/git' | path expand })

# Kubernetes
# alias awp = let-env AWS_PROFILE = (open --raw ~/.aws/config | lines | parse "[profile {profile}]" | get profile | nufzf)
# alias awc = let-env AWS_PROFILE = (open --raw ~/.aws/credentials | lines | parse "[{profile}]" | get profile | nufzf)
# alias kbp = do { kubectl config use-context (kubectl config get-contexts --no-headers | lines | parse -r "[\*]?\s*(?P<Context>\S*).*" | get Context | nufzf) }

alias vim = nvim

# Change directory to the path OR, if the path is empty, stay.
def res_or_pwd [res] {
    if ($res | is-empty) { pwd | str trim } else { $res }
}

# Skip values that are empty
def "not empty" [] {
	each { |it| if ($it | is-empty) { } else { $it } }
}

# https://carapace-sh.github.io/carapace-bin/setup.html#nushell
mkdir ($nu.data-dir | path join "vendor/autoload")
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

# https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# https://docs.atuin.sh/guide/installation/
mkdir ($nu.data-dir | path join "vendor/autoload")
atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

