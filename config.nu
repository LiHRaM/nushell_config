$env.REPOS_DIR = (if ((sys host).name == "Windows") { 'C:\git' } else { '~/git' | path expand })

mkdir ($nu.data-dir | path join "vendor/autoload")

# https://carapace-sh.github.io/carapace-bin/setup.html#nushell
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

# Requires Nushell 0.96+
fnox activate nu | save -f ($nu.data-dir | path join "vendor/autoload/fnox.nu")

# https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# https://docs.atuin.sh/guide/installation/
atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

# worktrunk.dev
wt config shell init nu | save -f ($nu.data-dir | path join "vendor/autoload/wt.nu")

# fnm
if (which fnm | is-not-empty) {
    ^fnm env --json | from json | load-env

    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version', 'package.json'] | any {|el| $el | path exists}}
            code: {|| ^fnm use --install-if-missing --silent-if-unchanged}
        }
    )
}

use utils.nu
