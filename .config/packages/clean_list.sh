# clean_list.sh — library with clean_list() function
# Usage: source this file, then call clean_list "/path/to/file"

clean_list() {
    local file="${1?Error: No file path provided}"

    grep -v '^[[:space:]]*$' "$file" |        # skip empty lines and whitespace-only lines
    grep -v '^[[:space:]]*#' |                # skip comment lines (with optional leading spaces)
    grep -Eo '^[^#]*' |                       # remove inline comments after package name
    grep -Eo '[[:print:]]+'                   # trim leading/trailing whitespace
}

