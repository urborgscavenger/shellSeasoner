#!/bin/sh
# undo_echo_python.sh
# Macht die python3->echo Änderung rückgängig

remove_python3_echo() {
    file="$1"
    shell_type="$2"
    marker="# python3_echo_marker"

    if [ ! -f "$file" ]; then
        echo "$shell_type: File $file does not exist, skipping"
        return
    fi

    grep -q "$marker" "$file"
    if [ $? -ne 0 ]; then
        echo "$shell_type: No python3 echo config found in $file, skipping"
        return
    fi

    echo "$shell_type: Removing python3 -> echo from $file"

    # Sed löscht den Marker + die direkt folgenden Zeilen der Funktion
    case "$shell_type" in
        bash|sh|dash|rbash|zsh)
            # Entfernt Marker + die nächste Zeile (python3() { ... })
            sed -i "/$marker/{N;d;}" "$file"
            ;;
        fish)
            # Entfernt Marker + alles bis 'end'
            awk -v marker="$marker" '
                BEGIN {skip=0}
                $0 ~ marker {skip=1; next}
                skip && $0 ~ /^end$/ {skip=0; next}
                !skip {print}
            ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
            ;;
        *)
            echo "$shell_type: Unsupported shell type for undo"
            ;;
    esac
}

# Bash/Zsh/Dash/rbash standard
remove_python3_echo "$HOME/.bashrc" bash
remove_python3_echo "$HOME/.zshrc" zsh
remove_python3_echo "$HOME/.profile" sh
remove_python3_echo "$HOME/.profile" dash
remove_python3_echo "$HOME/.profile" rbash

# Fish
remove_python3_echo "$HOME/.config/fish/config.fish" fish

echo "Undo done! Lade deine Shells neu oder source die Dateien, z.B.:"
echo "source ~/.bashrc"
echo "source ~/.zshrc"
echo "source ~/.config/fish/config.fish"