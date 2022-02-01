# Run PackerSync in headless nvim, waiting until install completes.
def "lihram sync nvim" [] {
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

# Enter Neovim in the configuration directory.
def "lihram edit nvim" [] {
  if (windows?) { cd $"($nu.env.LOCALAPPDATA)/nvim"; nvim } { echo "This is only supported on Windows!" } 
}
