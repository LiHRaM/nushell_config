# Run PackerSync in headless nvim, waiting until install completes.
def "lihram sync nvim" [] {
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}
