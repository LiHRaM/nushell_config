source ./hosts.nu

def "venv deactivate" [] {
	let path-name = if (windows?) { "Path" } else { "PATH" }
	let-env $path-name = $nu.env.VENV_OLD_PATH
	unlet-env VIRTUAL_ENV
	unlet-env VENV_OLD_PATH
}

