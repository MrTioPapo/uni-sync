#!/usr/bin/env fish

set BIN_PREFIX /usr/local/sbin
set CONF_PREFIX /etc/uni-sync

# Check for Rust Function
function check_rust
    echo '🦀 Checking for Rust'
    if not command -v rustc >/dev/null
        echo '⛔ Could not locate Rust Compiler ⛔'
        echo 'Try running:'
        echo 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh'
        exit 1
    else
        echo '✅ Its Rusty!'
    end
end

function build_app
    if test -f "uni-sync"
        rm uni-sync
    end

    echo '⚒  Building Uni-Sync'
    cargo build --release

    if not test -f "target/release/uni-sync"
        echo '⛔ Build Failed ⛔'
        exit 1
    end

    mv target/release/uni-sync .
    rm -rf ./target
end

function install_app
    # Create a multi-line string variable with the service file content.
    set SERVICE_CONTENT "[Unit]
Description=Uni-Sync service
[Service]
ExecStart=$BIN_PREFIX/uni-sync $CONF_PREFIX/uni-sync.json
[Install]
WantedBy=multi-user.target
"
    # Echo the variable's content into the file
    echo "$SERVICE_CONTENT" > uni-sync.service

    sudo mv -f uni-sync.service /etc/systemd/system
    sudo mv -f uni-sync $BIN_PREFIX

    sudo systemctl enable uni-sync
    sudo systemctl restart uni-sync
end

check_rust
build_app

read -P "Would you like to install as Service? [N/y]: " -n 1 reply
echo
if string match -r '^[Yy]$' -- $reply
    install_app
end
