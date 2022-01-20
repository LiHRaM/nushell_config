# Nushell configs

A collection of configurations I dynamically load using my `config.toml`.

## Setup

We make the following assumptions:

Configurations are stored in the `$HOME/.nushell` directory, grouped by repository.
E.g. `$HOME/.nushell/lihram/*.nu`.

Setup directory:

```
# Starting from your home directory
mkdir ".nushell"
cd ".nushell"

git clone git@github.com:LiHRaM/nushell_config.git lihram
```

Add the following to your `startup` variable in `config.toml`:

```
startup = [
  'mkdir ~/.nushell; mkdir ~/.cache/nu;',
  'ls ~/.nushell/* | where type == "Dir" | get name | each { ls $it } | get name | each { $"source ($it)" } | str collect (char newline) | save ~/.cache/nu/mod.nu',
  'source ~/.cache/nu/mod.nu'
]
```

It should automatically find and load all the scripts in this repository.
