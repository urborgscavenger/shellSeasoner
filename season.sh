#!/bin/sh
# setup_echo_python.sh
# Dieses Skript fügt in allen gängigen Shells ein "python3 -> echo" Mapping hinzu

# Funktion zum Einfügen in Datei, nur einmal
add_python3_echo() {
    file="$1"
    shell_type="$2"
    marker="# python3_echo_marker"
    
    # Prüfen, ob schon vorhanden
    grep -q "$marker" "$file" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "$shell_type: Already configured in $file"
        return
    fi

    echo "$shell_type: Adding python3 -> echo in $file"

    case "$shell_type" in
        bash|sh|dash|rbash)
            echo "" >> "$file"
            echo "$marker" >> "$file"
            echo "python3() { echo 'segmentation fault (core dumped)'; }" >> "$file"
            ;;
        zsh)
            echo "" >> "$file"
            echo "$marker" >> "$file"
            echo "python3() { echo 'segmentation fault (core dumped)'; }" >> "$file"
            ;;
        fish)
            echo "" >> "$file"
            echo "$marker" >> "$file"
            echo "function python3" >> "$file"
            echo "    echo 'segmentation fault (core dumped)'" >> "$file"
            echo "end" >> "$file"
            ;;
        *)
            echo "$shell_type: Unsupported shell type for auto config"
            ;;
    esac
}

# Bash/Zsh/Dash/rbash standard
add_python3_echo "$HOME/.bashrc" bash
add_python3_echo "$HOME/.zshrc" zsh
add_python3_echo "$HOME/.profile" sh
add_python3_echo "$HOME/.profile" dash
add_python3_echo "$HOME/.profile" rbash

# Fish
mkdir -p "$HOME/.config/fish"
add_python3_echo "$HOME/.config/fish/config.fish" fish

echo "Done! Lade deine Shells neu oder source die Dateien, z.B.:"
echo "source ~/.bashrc"
echo "source ~/.zshrc"
echo "source ~/.config/fish/config.fish"