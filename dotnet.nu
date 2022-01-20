# Runs `dotnet test`, filtering out end-to-end tests.
def "dotnet unit" [] { dotnet test --filter TestCategory!=E2ETests }

# Runs `dotnet test`, with a filter matching only end-to-end tests.
def "dotnet e2e" [] { dotnet test --filter TestCategory=E2ETests }

# Runs `dotnet format` with warn level `info`.
def "dotnet fmt" [] { dotnet format -w info }
