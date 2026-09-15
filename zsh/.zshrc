# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set -o vi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# --- oh-my-zsh plugin compatibility shims ---
# We load a few oh-my-zsh plugins through zim (see ~/.zimrc), but not the
# oh-my-zsh loader itself, so the variables/functions it used to provide have
# to be set up by hand.

# The tmux plugin reads these on init.
ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOCONNECT=true

# The kubectl and docker plugins regenerate their completions into
# $ZSH_CACHE_DIR/completions. Without this the path resolves to
# "/completions/_kubectl" and the =( ... ) temp file substitution fails.
export ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh
[[ -d $ZSH_CACHE_DIR/completions ]] || mkdir -p $ZSH_CACHE_DIR/completions

# The docker plugin uses is-at-least for version comparison.
autoload -Uz is-at-least

# Extra completion functions (e.g. _sesh, bun's _bun, and the completions the
# plugins above generate), must be in fpath before zim's completion module
# runs compinit.
fpath+=(~/.zsh/completions "$HOME/.bun" $ZSH_CACHE_DIR/completions)

# --- zimfw (https://github.com/zimfw/zimfw) ---
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /opt/homebrew/opt/zimfw/share/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

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
#
export EDITOR='nvim'

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

alias lg="lazygit"
alias oc="opencode"

ff () {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {2}")+abort'
}

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

export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/application_default_credentials.json
export GOOGLE_CLOUD_PROJECT=vglafirov-bef12636
export VERTEX_LOCATION=global   # defaults to 'global'


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

alias v='nvim'

export GOPRIVATE=gitlab.com

eval "$(zoxide init zsh)"

eval "$(mise activate zsh)"


export K9S_CONFIG_DIR=~/.config/k9s

export DOCKER_HOST=unix:///Users/vglafirov/.colima/default/docker.sock

export GITLAB_DOCKER_SOCKET="$HOME/.colima/default/docker.sock"


export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

sec() {
  eval "$(op signin --account my)"
  
  export NOTION_SECRET=$(op read "op://private/notion-secret/credential")
  export NOTION_API_KEY=$(op read "op://private/notion-api-key/credential")
  export GITLAB_TOKEN=$(op read "op://private/gitlab-api-token/credential")
  export GITLAB_VIM_URL=https://gitlab.com
  export RELEASE_BOT_OPS_TOKEN=$(op read "op://private/release-bot-ops-token/credential")
  export OPENAI_API_KEY=$(op read "op://private/openapi-key/password") 
  export DEEPSEEK_API_KEY=$(op read "op://private/deepseek-api/credential") 
  export ANTHROPIC_API_KEY=$(op read "op://private/anthropic-api/credential") 
  export GEMINI_API_KEY=$(op read "op://private/gemini-api/credential") 
  export GROQ_API_KEY=$(op read "op://private/groq-api/credential") 
  export LITELLM_API_KEY=$(op read "op://private/litellm-api/credential") 
  export GITLAB_OAUTH_CLIENT_ID=$(op read "op://private/opencode-gitlab-auth-plugin/username") 
  export HOMEASSISTANT_TOKEN=$(op read "op://private/home-assistant-token/credential") 

  eval "$(op signin --account gitlab)"
  export GRAFANA_SERVICE_ACCOUNT_TOKEN=$(op read "op://Engineering/Grafana playground API token/Tokens/developer-playground-key API Key")
  export OPS_GITLAB_TOKEN=$(op read "op://Employee/ops-gitlab-net-pat/credential")
}

hotline(){
  eval "$(op signin --account my)"
  export HOTLINE_GITLAB_TOKEN=$(op read "op://private/gitlab-hotline-pat/credential")
}

selfhosted() {
  export GITLAB_INSTANCE_URL=https://gitlab.caproni.test
  # This instance routes Duo through GitLab's STAGING AI gateway via Cloud
  # Connector. The direct_access token is minted for the staging realm, so the
  # provider must send model/proxy requests to the staging gateway. Without
  # this it defaults to https://cloud.gitlab.com and fails with a connection
  # error ("typo in the url or port?").
  export GITLAB_AI_GATEWAY_URL=https://cloud.staging.gitlab.com
  export NODE_EXTRA_CA_CERTS=/Users/vglafirov/.local/share/caproni/caproni/pki/ca.crt
  export GITLAB_OAUTH_CLIENT_ID=d20e6bba067cb2b016a0d5998ec3534f0a8bea75a8624fb6513cc40fb0fabf1d
  eval "$(op signin --account my)"
  export GITLAB_TOKEN=$(op read "op://private/gitlab-api-token-self-hosted/credential")
}

staging() {
  export GITLAB_INSTANCE_URL=https://staging.gitlab.com
  export GITLAB_AI_GATEWAY_URL=https://cloud.staging.gitlab.com
  eval "$(op signin --account my)"
  export GITLAB_TOKEN=$(op read "op://private/gitlab-api-token-staging/credential")
}


staging() {
  export GITLAB_AI_GATEWAY_URL=https://cloud.staging.gitlab.com
  export GITLAB_INSTANCE_URL=https://staging.gitlab.com
  export GITLAB_OAUTH_CLIENT_ID=63b9b9a0654d6abd8a6e624f38eb42668a92ee16345667b2bf9a394050206e17
  eval "$(op signin --account my)"
  export GITLAB_TOKEN=$(op read "op://private/gitlab-api-token-staging/credential")
}

mproxy() {
 export HTTP_PROXY=http://127.0.0.1:8035
 export HTTPS_PROXY=http://127.0.0.1:8035
 export NODE_EXTRA_CA_CERTS=~/.mitmproxy/mitmproxy-ca-cert.pem
 echo "run: mitmproxy -p 8035"
}

export HOMEASSISTANT_URL="https://home.vglafirov.com"

export GRAFANA_URL="https://dashboards.gitlab.net"
export OLLAMA_HOST=0.0.0.0

function gtx() {
  local config=$(gcloud config configurations list --format="value(name)" | fzf --height 40% --reverse --header="Select gcloud configuration")
  
  if [[ -n "$config" ]]; then
    gcloud config configurations activate "$config"
    
    # Get the account and project from the activated configuration
    local account=$(gcloud config get-value account)
    local project=$(gcloud config get-value project)
    
    echo "Switched to configuration: $config"
    echo "Account: $account"
    echo "Project: $project"
    
    # Optional: Auto-refresh GKE credentials if you have a cluster
    # gcloud container clusters get-credentials CLUSTER_NAME --region=REGION
  fi
}

function gapp() {
  local config=$(gcloud auth list --format=json | jq -r ".[].account" | fzf --height 40% --reverse --header="Select gcloud account")
  
  if [[ -n "$config" ]]; then
    gcloud config set account "$config"
    gcloud auth application-default login
    echo "Switched to account: $config"
  fi
}

# function gapp() {
#   local config=$(gcloud auth list --format=json | jq ".[].account" | tr -d "\"" | fzf --height 40% --reverse --header="Select gcloud account")
#
#   if [[ -n "$config" ]]; then
#     gcloud auth application-default login $config
#     echo "Switched to account: $config"
#   fi
# }

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

. "$HOME/.local/bin/env"

export SEARXNG_API_URL="https://search.vglafirov.com/search"

export PATH="$HOME/go/bin:$PATH"

# Added by GDK bootstrap
eval "$(/opt/homebrew/bin/mise activate zsh)"

# ${UserConfigDir}/zsh/.zshrc
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

eval "$(atuin init zsh)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by GitLab Knowledge Graph installer
export PATH="$HOME/.local/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vglafirov/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vglafirov/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vglafirov/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vglafirov/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# opencode
export PATH=/Users/vglafirov/.opencode/bin:$PATH
export OPENCODE_EXPERIMENTAL_WORKSPACES=true
