#!/bin/sh
echo -ne '\033c\033]0;GMTKJAM2025\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/GMTKJAM2025.x86_64" "$@"
