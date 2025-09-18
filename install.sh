#!/bin/bash

# Navigate to the dotfiles directory
cd ~/src/dotfiles

# Define an array of packages to stow
PACKAGES=("git" "nvim" "tmux" "zsh" "zsh-themes")

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "stow could not be found. Please install it first (e.g., sudo apt install stow)."
    exit 1
fi

# Function to handle overwriting existing files
handle_overwrite() {
    local target_path="$1"

    # Check if the target path exists and is not a symlink to the correct source
    if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
        read -p "$target_path already exists. Do you want to remove it to create a symlink? (y/N): " choice
        case "$choice" in
            y|Y )
                echo "Removing $target_path..."
                rm -rf "$target_path"
                ;;
            * )
                echo "Skipping symlink creation for $target_path."
                return 1
                ;;
        esac
    fi
    return 0
}

# --- Check and install TPM (Tmux Plugin Manager) and Catppuccin theme ---
if [[ " ${PACKAGES[@]} " =~ " tmux " ]]; then
    TPM_PATH="$HOME/.tmux/plugins/tpm"
    if [ ! -d "$TPM_PATH" ]; then
        echo "TPM not found. Installing it to $TPM_PATH..."
        mkdir -p "$HOME/.tmux/plugins"
        git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
        echo "TPM installed successfully."
    else
        echo "TPM is already installed."
    fi

    CATPPUCCIN_PATH="$HOME/.config/tmux/plugins/catppuccin/tmux"
    if [ ! -d "$CATPPUCCIN_PATH" ]; then
        echo "Catppuccin theme not found. Installing it to $CATPPUCCIN_PATH..."
        mkdir -p "$HOME/.config/tmux/plugins/catppuccin"
        git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "$CATPPUCCIN_PATH"
        echo "Catppuccin theme installed successfully."
    else
        echo "Catppuccin theme is already installed."
    fi
fi
# Loop through each package and stow it
for pkg in "${PACKAGES[@]}"; do
    if [ "$pkg" == "nvim" ]; then
        # Special handling for Neovim
        NVIM_DEST="$HOME/.config/nvim"
        echo "Handling Neovim configuration..."

        mkdir -p "$NVIM_DEST"

        files_to_check=$(find "$pkg" -maxdepth 1 -mindepth 1)
        for file in $files_to_check; do
            target_path="$NVIM_DEST/$(basename "$file")"
            if ! handle_overwrite "$target_path"; then
                continue 2
            fi
        done

        echo "Stowing nvim..."
        stow -v --target="$NVIM_DEST" "$pkg"

    elif [ "$pkg" == "zsh-themes" ]; then
        # Special handling for zsh themes
        ZSH_THEMES_DEST="$HOME/.oh-my-zsh/themes"
        echo "Handling zsh themes configuration..."

        mkdir -p "$ZSH_THEMES_DEST"

        files_to_check=$(find "$pkg" -maxdepth 1 -mindepth 1)
        for file in $files_to_check; do
            target_path="$ZSH_THEMES_DEST/$(basename "$file")"
            if ! handle_overwrite "$target_path"; then
                continue 2
            fi
        done

        echo "Stowing zsh themes..."
        stow -v --target="$ZSH_THEMES_DEST" "$pkg"

    else
        # General handling for other packages (git, tmux, zsh)
        echo "Stowing $pkg..."
        pkg_files=$(find "$pkg" -maxdepth 1 -mindepth 1)
        for file in $pkg_files; do
            target_path="$HOME/$(basename "$file")"
            if ! handle_overwrite "$target_path"; then
                continue 2
            fi
        done

        stow -v --target="$HOME" "$pkg"
    fi
done
