# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

set -o vi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git
kubectl
golang
docker
aws
gcloud
)

ZSH_TMUX_AUTOSTART=false

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ktx="kubectx"
alias kns="kubens"
alias nx="nix-shell --run $SHELL"

ff () {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {2}")+abort'
}

unalias kcp

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval $(/opt/homebrew/bin/brew shellenv)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export MOUNTPOINT=/Volumes/GitLab

export GNUPGHOME=${GNUPGHOME:-$HOME/.gnupg}

#export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

# export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"
source ~/.config/op/plugins.sh

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

VAULT_PROXY_ADDR="socks5://localhost:18200"

eval "$(direnv hook zsh)"

login1p() {
  # Trick: uncomment the following link to open your 1password GUI to the right place
  # for easy copy paste of password
  eval "$(op signin --account gitlab.1password.com)"
  direnv reload
}

fcd() {
        local dir
        dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
}

def ff() {
    aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

alias vim='nvim'

export GOPRIVATE=gitlab.com

eval "$(zoxide init zsh)"

eval "$(mise activate zsh)"


export K9S_CONFIG_DIR=~/.config/k9s

export DOCKER_HOST=unix:///Users/vglafirov/.colima/default/docker.sock


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vglafirov/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vglafirov/google-cloud-sdk/path.zsh.inc'; fi

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

sec() {
  eval "$(op signin --account my)"
  
  export NOTION_SECRET=$(op read "op://private/notion-secret/credential")
  export NOTION_API_KEY=$(op read "op://private/notion-api-key/credential")
  export GITLAB_TOKEN=$(op read "op://private/gitlab-token/credential")
  export GITLAB_VIM_URL=https://gitlab.com
  export RELEASE_BOT_OPS_TOKEN=$(op read "op://private/release-bot-ops-token/credential")
  export OPENAI_API_KEY=$(op read "op://private/openapi-key/password") 
  export DEEPSEEK_API_KEY=$(op read "op://private/deepseek-api/credential") 
  export ANTHROPIC_API_KEY=$(op read "op://private/anthropic-api/credential") 
  export GEMINI_API_KEY=$(op read "op://private/gemini-api/credential") 
  export GROQ_API_KEY=$(op read "op://private/groq-api/credential") 
  export LITELLM_API_KEY=$(op read "op://private/litellm-api/credential") 
}

export OLLAMA_HOST=0.0.0.0


function gtx() {
  local config=$(gcloud config configurations list --format="value(name)" | fzf --height 40% --reverse --header="Select gcloud configuration")
  
  if [[ -n "$config" ]]; then
    gcloud config configurations activate "$config"
    echo "Switched to configuration: $config"
  fi
}

function gapp() {
  local config=$(gcloud auth list --format=json | jq ".[].account" | tr -d "\"" | fzf --height 40% --reverse --header="Select gcloud account")
  
  if [[ -n "$config" ]]; then
    gcloud auth application-default login $config
    echo "Switched to account: $config"
  fi
}

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

. "$HOME/.local/bin/env"

export SEARXNG_API_URL="https://search.vglafirov.com/search"

# Added by Windsurf
export PATH="/Users/vglafirov/.codeium/windsurf/bin:$PATH"

# Added by GDK bootstrap
eval "$(/opt/homebrew/bin/mise activate zsh)"

# ${UserConfigDir}/zsh/.zshrc
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

eval "$(atuin init zsh)"
