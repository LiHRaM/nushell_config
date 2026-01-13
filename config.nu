$env.REPOS_DIR = (if ((sys host).name == "Windows") { 'C:\git' } else { '~/git' | path expand })

mkdir ($nu.data-dir | path join "vendor/autoload")

# https://carapace-sh.github.io/carapace-bin/setup.html#nushell
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

# https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# https://docs.atuin.sh/guide/installation/
atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

# worktrunk.dev
# wt config shell init nu | save -f ($nu.data-dir | path join "vendor/autoload/wt.nu")
#
# TODO(Hilmar): Remove when https://github.com/max-sixty/worktrunk/pull/535 is merged.
def --env --wrapped wt [...args: string] {
    let directive_file = (mktemp)

    let result = do {
        with-env { WORKTRUNK_DIRECTIVE_FILE: $directive_file } {
            ^wt ...$args
        }
    } | complete

    print $result.stdout
    print --stderr $result.stderr

    if ($directive_file | path exists) and (open $directive_file --raw | str trim | is-not-empty) {
        let directive = open $directive_file --raw | str trim
        # Parse directive: worktrunk emits "cd <path>" for directory changes
        if ($directive | str starts-with "cd ") {
            let target_dir = $directive | parse "cd '{target_dir}'" | get 0.target_dir
            cd $target_dir
        }
    }

    rm -f $directive_file

    if $result.exit_code != 0 {
        error make { msg: $"{{ cmd }} exited with code ($result.exit_code)" }
    }
}
# END TODO

# fnm
if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env

    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version', 'package.json'] | any {|el| $el | path exists}}
            code: {|| ^fnm use --install-if-missing}
        }
    )
}

use utils.nu
