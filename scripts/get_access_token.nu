# This formats the access token for web requests.
export def get_auth_header [] {
    { "Authorization": $"Bearer (gcloud auth print-identity-token)" }
}

# Curl with Auth.
export alias ca = curl -H (get_auth_header | to text)

# View the curl'd output.
# Example:
# ```
# ca https://www.example.com | cav
# ```
export alias cav = lynx -stdin

