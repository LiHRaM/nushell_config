# calculate required tabs/spaces to get a nicely aligned table
let tablen = 8
let max-len = (help commands | get subcommands |  each { $it.name | str length } | math max)
let max-indent = ($max-len / $tablen | into int)

def pad-tabs [input-name] {
   let input-length = ($input-name| str length) 
    let required-tabs = $max-indent - ($"($input-length / $tablen | into int)" | str to-int)
    echo $"( seq $required-tabs | reduce -f "" {$acc + (char tab)})"
}

alias fcs = fuzzy-command-search
def fuzzy-command-search [] {
    help (echo (help commands | get subcommands | each {
            let name = ($it.name | str trim | ansi strip)
            $"(
                $name
            )( pad-tabs $name
            )(
                $it.description
            )"
    }) (
    help commands | reject subcommands | each {
            let name = ($it.name | str trim | ansi strip)
            $"(
                $name
            )(
               pad-tabs $name
            )(
                $it.description
            )"
    }) | str collect (char nl) | fzf | split column (char tab) | get Column1 | clip; paste )
}

def "fuzzy history search" [] {
	open $nu.history-path | lines | skip 1 | nufzf
}
