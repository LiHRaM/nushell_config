let-env config = {
    show_banner: false
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
            to_string: { |v| $v | str collect (char esep) }
        }
        "Path": {
            from_string: { |s| $s | split row (char esep) }
            to_string: { |v| $v | str collect (char esep) }
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
    LESSCHARSET: "UTF-8",
    EDITOR: "hx",

    # 3rd party programs
    FZF_DEFAULT_OPTS: "--layout=reverse",
    CARGO_TARGET_DIR: ("~/.cargo/target" | path expand),
}
