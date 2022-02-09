# A Nushell-compatible fzf wrapper
def nufzf [] {
	# fzf expects a newline separated string input,
	# and returns a newline-terminated result.
	str collect (char newline) | fzf --height=40% | str trim | not empty
}

# Skip values that are empty
def "not empty" [] {
	each { if ($it | empty?) { } else { $it } }
}
