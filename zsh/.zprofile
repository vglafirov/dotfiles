# Login-shell setup. Keep this minimal: every new terminal tab is a login shell
# on macOS, so anything here adds to startup time. Most PATH setup lives in
# ~/.zshrc (section 2). Python is managed by mise, so pyenv is not initialised.

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Added by Snowflake SnowflakeCLI installer v1.0
export PATH=/Applications/SnowflakeCLI.app/Contents/MacOS/:$PATH
