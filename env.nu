let-env PATH = ($env.PATH | prepend "/Users/lihram/Library/Application Support/carapace/bin")

let carapace_completer = {|spans| 
  carapace $spans.0 nushell $spans | from json
}

let-env config = {
  show_banner: false
  completions: {
    external: {
      enable: true
      completer: $carapace_completer
    }
  }
}


load-env {
    # PROMPT_COMMAND: "",
    # PROMPT_COMMAND_RIGHT: "",
    # PROMPT_INDICATOR: "; ",
    # PROMPT_INDICATOR_VI_INSERT: { ": " },
    # PROMPT_INDICATOR_VI_NORMAL: { "; " },
    # PROMPT_MULTILINE_INDICATOR: { "::: " },
    ENV_CONVERSIONS: {
        "PATH": {
            from_string: { |s| $s | split row (char esep) }
            to_string: { |v| $v | str join (char esep) }
        }
        "Path": {
            from_string: { |s| $s | split row (char esep) }
            to_string: { |v| $v | str join (char esep) }
        }
    },
    NU_LIB_DIRS: [
        ($nu.config-path | path dirname | path join 'scripts')
    ],
    NU_PLUGIN_DIRS: [
        ($nu.config-path | path dirname | path join 'plugins')
    ],

    # Useful OS defaults
    LANG: "en_DK",
    LC_ALL: "C.UTF-8",
    LC_CTYPE: "UTF-8",
    LESSCHARSET: "UTF-8",
    EDITOR: "hx",

    # 3rd party programs
    FZF_DEFAULT_OPTS: "--layout=reverse",
    CARGO_TARGET_DIR: ("~/.cargo/target" | path expand),
    USE_GKE_GCLOUD_AUTH_PLUGIN: false,
}
