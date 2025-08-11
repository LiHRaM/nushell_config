# Convenience function for trailing structured JSON logs.
# Ignores any logs that aren't JSON.
export def "logs tail" [
  fields: string = "{time, severity, message}"
] {
  ^jq -Rrc $'. as $line | fromjson? | ($fields)'
}
