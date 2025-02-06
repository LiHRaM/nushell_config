$env.PATH = ($env.PATH | prepend "/Users/lihram/Library/Application Support/carapace/bin")

let carapace_completer = {|spans| 
  let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)

  # overwrite
  let spans = (if $expanded_alias != null {
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else {
    $spans
  })

  carapace $spans.0 nushell ...$spans | from json
}

$env.config = {
  show_banner: false
  completions: {
    external: {
      enable: true
      completer: $carapace_completer
    }
  },
  keybindings: [
  {
    name: fuzzy_repos
    modifier: control
    keycode: char_p
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "do {
          commandline edit --insert (
            ein tool find $env.REPOS_DIR
              | fzf --height=40% --preview='ls {}'
          )
        }"
      }
    ]
  },
  {
    name: fuzzy_directories
    modifier: control
    keycode: char_i
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "do {
          commandline edit --insert (
            ls | where type == dir | get name | to text
               | fzf --height=40% --preview='ls {}'
          )
        }"
      }
    ]
  }
  {
    name: fuzzy_history
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: [
    {
      send: ExecuteHostCommand
      cmd: "do {
            commandline edit --insert (
              history
              | get command
              | reverse
              | uniq
              | str join (char -i 0)
              | fzf --scheme=history 
                  --read0
                  --layout=reverse
                  --height=40%
                  --bind 'ctrl-/:change-preview-window(right,70%|right)'
                  --preview='echo -n {} | nu --stdin -c \'nu-highlight\''
                  # Run without existing commandline query for now to test composability
                  # -q (commandline)
              | decode utf-8
              | str trim
            )
          }"
        }
      ]
    }
  ]
}


load-env {
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
    LANG: "en_US",
    LC_ALL: "C.UTF-8",
    LC_CTYPE: "UTF-8",
    LESSCHARSET: "UTF-8",
    EDITOR: "hx",

    # 3rd party programs
    FZF_DEFAULT_OPTS: "--layout=reverse",
    CARGO_TARGET_DIR: ("~/.cargo/target" | path expand),
    USE_GKE_GCLOUD_AUTH_PLUGIN: false,
}
