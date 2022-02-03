# nvim.nu
def "lihram nvim" [] { help lihram nvim }

# Run PackerSync in headless nvim, waiting until install completes.
def "lihram nvim sync" [] {
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

# Enter Neovim in the configuration directory.
def "lihram nvim edit" [] {
  if (windows?) { cd $"($nu.env.LOCALAPPDATA)/nvim"; nvim } { echo "This is only supported on Windows!" } 
}
