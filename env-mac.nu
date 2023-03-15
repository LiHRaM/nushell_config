# This can cause issues with other scripts. (Such as nix.)
hide-env LC_ALL;

let-env PATH = (
    (ls /etc/paths.d/).name 
    | prepend /etc/paths 
    | each { |path| open $path | lines } 
    | flatten 
    | path expand
)
let-env DOCKER_DEFAULT_PLATFORM = "linux/amd64"