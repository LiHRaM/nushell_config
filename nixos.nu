# Switch to the nixos configuration and enter Neovim
def "lihram nixos config" [] {
    if (nixos?) { cd "~/.nixos"; eval $nu.env.EDITOR } { echo "Command only supported on NixOS" }
}
