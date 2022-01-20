alias awp = let-env AWS_PROFILE = (open --raw ~/.aws/config | lines | parse "[profile {profile}]" | get profile | nufzf)
alias awc = let-env AWS_PROFILE = (open --raw ~/.aws/credentials | lines | parse "[{profile}]" | get profile | nufzf)
alias vim = nvim
alias repos = do {
	gix tools find $nu.env.REPOS_DIR | sd $"\(char psep)\.git$" "" | lines | nufzf | each { cd $it }
}
alias cdd = do {
	ls | where type == Dir | get name | nufzf | each { cd $it }
}
alias kbp = do { kubectl config use-context (kubectl config get-contexts --no-headers | lines | parse -r "[\*]?\s*(?P<Context>\S*).*" | get Context | nufzf) }
alias NVIM_HOME = $"($nu.env.APPDATA)/../Local/nvim"
