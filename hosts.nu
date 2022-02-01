def windows? [] {
    (sys).host.name == "Windows"
}

def nixos? [] {
    (sys).host.name == "NixOS"
}
