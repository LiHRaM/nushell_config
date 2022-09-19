let-env PATH = (
    (ls /etc/paths.d/).name 
    | prepend /etc/paths 
    | each { |path| open $path | lines } 
    | flatten 
    | path expand
)