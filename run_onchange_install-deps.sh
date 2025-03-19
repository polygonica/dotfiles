#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Define all dependencies and their installation handlers
declare -A DEPENDENCIES=(
    # Common packages that use standard package manager installation
    ["curl"]="standard"
    ["wget"]="standard"
    ["tmux"]="standard"
    ["vim"]="standard"
    ["neovim"]="standard"
    ["wezterm"]="wezterm"
    ["starship"]="starship"
)

# Function to install packages using the appropriate package manager
install_packages() {
    local packages=("$@")
    local pkg_manager="$1"
    shift

    case "$pkg_manager" in
        "brew")
            brew install "${packages[@]}"
            ;;
        "apt")
            sudo apt install -y "${packages[@]}"
            ;;
        "dnf")
            sudo dnf install -y "${packages[@]}"
            ;;
        "pacman")
            sudo pacman -S --noconfirm "${packages[@]}"
            ;;
        *)
            echo "Unsupported package manager: $pkg_manager"
            exit 1
            ;;
    esac
}

# Function to install Starship
install_starship() {
    echo "Installing Starship..."
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
}

# Function to install Wezterm
install_wezterm() {
    local pkg_manager="$1"

    echo "Installing Wezterm..."
    case "$pkg_manager" in
        "brew")
            brew install wezterm
            ;;
        "apt")
            # Add Wezterm's official repository
            curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
            echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
            sudo apt update
            sudo apt install wezterm
            ;;
        "dnf")
            sudo dnf copr enable -y atim/wezterm
            sudo dnf install -y wezterm
            ;;
        "pacman")
            sudo pacman -S --noconfirm wezterm
            ;;
    esac
}

# Function to install dependencies based on OS
install_deps() {
    local os="$1"
    local pkg_manager="$2"

    # Update package manager if needed
    case "$pkg_manager" in
        "apt")
            sudo apt update
            ;;
        "pacman")
            sudo pacman -Syu --noconfirm
            ;;
    esac

    # Install each dependency using its appropriate handler
    for dep in "${!DEPENDENCIES[@]}"; do
        # Skip if the dependency is already installed
        if command_exists "$dep"; then
            echo "$dep is already installed, skipping..."
            continue
        fi

        local handler="${DEPENDENCIES[$dep]}"
        case "$handler" in
            "standard")
                install_packages "$pkg_manager" "$dep"
                ;;
            "starship")
                install_starship
                ;;
            "wezterm")
                install_wezterm "$pkg_manager"
                ;;
            *)
                echo "Unknown handler for $dep: $handler"
                exit 1
                ;;
        esac
    done
}

# Main installation logic
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! command_exists brew; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    install_deps "darwin" "brew"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command_exists apt; then
        install_deps "linux" "apt"
    elif command_exists dnf; then
        install_deps "linux" "dnf"
    elif command_exists pacman; then
        install_deps "linux" "pacman"
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
else
    echo "Unsupported operating system"
    exit 1
fi 