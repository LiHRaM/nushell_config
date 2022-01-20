# Use fzf to checkout to existing branches
def "git co" [] {
	git branch | lines | parse -r "^\s+(?P<Branch>.*)$" | get Branch | nufzf | each { git checkout $it }
}
