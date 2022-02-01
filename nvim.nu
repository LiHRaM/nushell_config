# Run PackerSync in headless nvim, waiting until install completes.
def "lihram nvim sync" [] {
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}
