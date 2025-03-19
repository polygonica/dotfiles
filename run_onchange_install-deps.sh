#!/bin/bash

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null
}

# Define standard packages
STANDARD_PACKAGES="curl wget tmux vim neovim"

# Function to install packages using the appropriate package manager
install_packages() {
    local pkg_manager="$1"
    shift
    local packages=("$@")

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
    if type starship &> /dev/null; then
        echo "Starship is already installed, skipping..."
        return
    fi
    echo "Installing Starship..."
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
}

# Function to install Wezterm
install_wezterm() {
    local pkg_manager="$1"

    if type wezterm &> /dev/null; then
        echo "Wezterm is already installed, skipping..."
        return
    fi

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

    # Install standard packages
    for pkg in $STANDARD_PACKAGES; do
        if type "$pkg" &> /dev/null; then
            echo "$pkg is already installed, skipping..."
            continue
        fi
        install_packages "$pkg_manager" "$pkg"
    done

    # Install special packages
    install_starship
    install_wezterm "$pkg_manager"
}

# Main installation logic
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! type brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    install_deps "darwin" "brew"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if type apt &> /dev/null; then
        install_deps "linux" "apt"
    elif type dnf &> /dev/null; then
        install_deps "linux" "dnf"
    elif type pacman &> /dev/null; then
        install_deps "linux" "pacman"
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
else
    echo "Unsupported operating system"
    exit 1
fi 