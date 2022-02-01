# Empty placeholder for custom commands
def lihram [] { }

# Enter this configuration directory
def "lihram nu config" [] {
  cd ("~/.nushell/lihram" | path expand); eval $nu.env.EDITOR
}

def eval [input: string] {
  nu -c $input
}
