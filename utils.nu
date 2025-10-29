use std/log

# Convenience function for trailing structured JSON logs.
# Ignores any logs that aren't JSON.
export def "logs tail" [
  fields: string = "{time, severity, message}"
] {
  ^jq -Rrc $'. as $line | fromjson? | ($fields)'
}

# A convenience function for running repetitive commands manually.
export def "listen" [
  closure: closure,          # The command to run when triggered.
  --no-clear                 # Whether to clear the screen between triggers.
  --trigger: string = enter, # The key that triggers this listener.
  --description: string,     # A description that will be shown at the beginning of each loop.
]: nothing -> nothing {
  let render = {
    if not $no_clear { clear }

    print "Listening for input. Press CTRL+C to exit."

    if ($description | is-not-empty) { print $description }
  }

  do $render


  loop {
    let input = (input listen --types [key])

    match $input {
      {code: c, modifiers: ["keymodifiers(control)"]} => {
        print "CTRL+C pressed. Exiting."; break
      }
      $match if $match.code == $trigger => {
        do $render
        do $closure | print
      }
      _ => {
        print $"Unrecognized input: ($input | to nuon)"
      }
    }
  }
}

# Load environment variables into a key-value structure for use with [load-env].
# Expects a json file `.env.json` in the format:
# 
# ```json
# {
#   "shared": {
#      "FOO": "BAR"
#   },
#   "staging": {
#      "BAZ": "QUUX"
#   }
# }
# ```
export def --env "env" [
  environment: string = "staging", # The environment to fetch from the configuration
  --file: path = ".env.json",      # The file containing the environment configuration
] {
  if ($file | path exists) == false {
    log error $"File ($file) does not exist."
    return null
  }

  let envs = (open $file)
  let available = ($envs | reject shared | columns)

  if ($environment in $available) == false {
    log error $"($environment) not found. Available: ($available)"
    return null
  }

  load-env (($envs | get shared) | merge ($envs | get $environment))
}
