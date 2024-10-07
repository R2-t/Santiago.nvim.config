!/bin/bash

# check if homebrew is installed
if ! which brew &> /dev/null; then
    echo "Homebrew is not installed. Please install it first."
    exit 1
fi

# check if nvim is installed and install it if not
if command -v nvim &> /dev/null; then
    echo "nvim is already installed. Skipping..."
else
    if brew install -q neovim &> /dev/null; then
        echo "nvim installed successfully."
    fi
fi

# check if rg is installed and install it if not
if command -V rg &> /dev/null; then
    echo "ripgrep is already installed. Skipping..."
else
    if brew install -q ripgrep &> /dev/null; then
        echo "ripgrep installed successfully."
    fi
fi

# check if jdtls is installed and install it if not
if command -v jdtls &> /dev/null; then
    echo "jdtls is already installed. Skipping..."
else
    if brew install -q jdtls &> /dev/null; then
        echo "jdtls installed successfully."
    fi
fi

# check if rustup is installed and install it if not
if command -v rustup &> /dev/null; then
    rustup component add rust-analyzer &> /dev/null
fi

# Download eclipse-java-google-style.xml and save it in $HOME/.local/share/eclipse/
path_google_style = "$HOME/.local/share/eclipse/"
name_google_style = "eclipse-java-google-style.xml"

if curl -sS -O "https://raw.githubusercontent.com/google/styleguide/refs/heads/gh-pages/${name_google_style}"; then
    echo "eclipse-java-google-style.xml downloaded successfully."
    mkdir -p "$path_google_style" && mv "$name_google_style" "$path_google_style"
else 
    echo "Failed to download eclipse-java-google-style.xml. Please check your internet connection."
fi
