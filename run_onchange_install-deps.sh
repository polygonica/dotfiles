#!/bin/bash

# Package name (for installation): command name (for checking if installed)
STANDARD_PACKAGES=(
    "curl:curl"
    "wget:wget"
    "tmux:tmux"
    "vim:vim"
    "neovim:nvim"
    "git:git"
    "python3:python3"
)

# Utility functions
command_exists() {
    type "$1" &> /dev/null
}

get_package_manager_cmd() {
    local pkg_manager="$1"
    local cmd_type="$2"  # "install" or "update"
    
    case "$cmd_type" in
        "install")
            case "$pkg_manager" in
                "brew")   echo "brew install" ;;
                "apt")    echo "sudo apt install -y" ;;
                "dnf")    echo "sudo dnf install -y" ;;
                "pacman") echo "sudo pacman -S --noconfirm" ;;
            esac
            ;;
        "update")
            case "$pkg_manager" in
                "apt")    echo "sudo apt update" ;;
                "pacman") echo "sudo pacman -Syu --noconfirm" ;;
            esac
            ;;
    esac
}

get_wezterm_install_cmd() {
    local pkg_manager="$1"
    
    case "$pkg_manager" in
        "brew")
            echo "brew install wezterm"
            ;;
        "apt")
            echo 'curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg && echo "deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *" | sudo tee /etc/apt/sources.list.d/wezterm.list && sudo apt update && sudo apt install -y wezterm'
            ;;
        "dnf")
            echo 'sudo dnf copr enable -y atim/wezterm && sudo dnf install -y wezterm'
            ;;
        "pacman")
            echo 'sudo pacman -S --noconfirm wezterm'
            ;;
    esac
}

check_and_install() {
    local package_name="$1"
    local command_name="$2"
    local installer="$3"
    shift 3
    local installer_args=("$@")

    if command_exists "$command_name"; then
        echo "$package_name is already installed (found $command_name), skipping..."
        return 0
    fi
    
    echo "Installing $package_name..."
    "$installer" "${installer_args[@]}"
}

update_package_manager() {
    local pkg_manager="$1"
    local update_cmd
    
    update_cmd=$(get_package_manager_cmd "$pkg_manager" "update")
    if [[ -n "$update_cmd" ]]; then
        echo "Updating package manager ($pkg_manager)..."
        eval "$update_cmd"
    fi
}

install_with_package_manager() {
    local pkg_manager="$1"
    shift
    local packages=("$@")
    
    local install_cmd
    install_cmd=$(get_package_manager_cmd "$pkg_manager" "install")
    if [[ -z "$install_cmd" ]]; then
        echo "Unsupported package manager: $pkg_manager"
        exit 1
    fi
    
    eval "$install_cmd ${packages[*]}"
}

# Special package installers
install_starship() {
    check_and_install "starship" "starship" sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
}

install_wezterm() {
    local pkg_manager="$1"
    local install_cmd
    
    install_cmd=$(get_wezterm_install_cmd "$pkg_manager")
    if [[ -z "$install_cmd" ]]; then
        echo "Unsupported package manager for Wezterm: $pkg_manager"
        return 1
    fi
    
    check_and_install "wezterm" "wezterm" bash -c "$install_cmd"
}

# Prepare the package manager
prepare_package_manager() {
    local pkg_manager="$1"
    
    if [[ "$OSTYPE" == "darwin"* && "$pkg_manager" == "brew" ]]; then
        if ! command_exists brew; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi
    
    update_package_manager "$pkg_manager"
}

# Install standard packages
install_standard_packages() {
    local pkg_manager="$1"
    
    for pkg_entry in "${STANDARD_PACKAGES[@]}"; do
        IFS=':' read -r package_name command_name <<< "$pkg_entry"
        check_and_install "$package_name" "$command_name" install_with_package_manager "$pkg_manager" "$package_name"
    done
}

# Install special packages
install_special_packages() {
    local pkg_manager="$1"
    
    install_starship
    install_wezterm "$pkg_manager"
}

# Main installation function
install_packages() {
    local pkg_manager="$1"

    prepare_package_manager "$pkg_manager"
    install_standard_packages "$pkg_manager"
    install_special_packages "$pkg_manager"
}

# Find the appropriate package manager for the current system
find_package_manager() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "brew"
        return 0
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        for pkg_manager in apt dnf pacman; do
            if command_exists "$pkg_manager"; then
                echo "$pkg_manager"
                return 0
            fi
        done
        return 1
    fi
    return 1
}

# Detect and install for the current system / package manager
pkg_manager=$(find_package_manager)
if [[ -n "$pkg_manager" ]]; then
    install_packages "$pkg_manager"
else
    echo "No supported package manager found"
    exit 1
fi
