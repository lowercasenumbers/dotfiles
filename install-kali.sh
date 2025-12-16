#!/bin/bash

# Kali-specific install script
# Installs nvim, tmux, and git configs while preserving the default Kali zsh

# Navigate to the dotfiles directory
cd ~/src/dotfiles

# Define packages to stow (no zsh or zsh-themes)
PACKAGES=("git" "nvim" "tmux")

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

    else
        # General handling for other packages (git, tmux)
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

# --- Optional: Add zsh_profile source to existing Kali zshrc ---
ZSHRC="$HOME/.zshrc"
ZSH_PROFILE_SOURCE="source ~/src/dotfiles/zsh/.zsh_profile"

if [ -f "$ZSHRC" ]; then
    if ! grep -qF "$ZSH_PROFILE_SOURCE" "$ZSHRC"; then
        read -p "Do you want to source .zsh_profile in your existing .zshrc? (y/N): " choice
        case "$choice" in
            y|Y )
                echo -e "\n# User Configuration\n$ZSH_PROFILE_SOURCE" >> "$ZSHRC"
                echo "Added .zsh_profile source to $ZSHRC"
                ;;
            * )
                echo "Skipping .zsh_profile integration."
                ;;
        esac
    else
        echo ".zsh_profile is already sourced in $ZSHRC"
    fi
fi

echo "Kali dotfiles installation complete!"
