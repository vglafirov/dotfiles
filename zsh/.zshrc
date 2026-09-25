# ---------------------------------------------------------------------------
# 2. PATH and tool managers
#    MUST run before zim (section 4). The oh-my-zsh kubectl and tmux plugins
#    `return` on line 1 when their binary is not in $commands, and the golang
#    and docker plugins skip their completion setup the same way. kubectl here
#    is a mise shim, so if mise activates later, every kubectl alias is
#    silently dropped.
# ---------------------------------------------------------------------------
# Static equivalent of `eval "$(brew shellenv)"` -- saves a ~40 ms subprocess.
export HOMEBREW_PREFIX=/opt/homebrew
export HOMEBREW_CELLAR=/opt/homebrew/Cellar
export HOMEBREW_REPOSITORY=/opt/homebrew
path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

export BUN_INSTALL="$HOME/.bun"
export KREW_ROOT="${KREW_ROOT:-$HOME/.krew}"

path=(
  "$KREW_ROOT/bin"
  "$HOME/go/bin"
  "$HOME/.local/bin"
  "$BUN_INSTALL/bin"
  "$HOME/.opencode/bin"
  /opt/homebrew/opt/mysql-client/bin
  $path
)

# uv
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# mise -- owns kubectl, helm, go, docker-cli, tmux, ...
eval "$(/opt/homebrew/bin/mise activate zsh)"

# Google Cloud SDK is mise-managed (gcloud + gke-gcloud-auth-plugin), so mise
# activation above already put it on PATH.

# ---------------------------------------------------------------------------
# 3. oh-my-zsh plugin compatibility shims
#    The omz plugins are loaded through zim (see ~/.zimrc) but the oh-my-zsh
#    loader itself is not, so what it used to provide is set up by hand.
# ---------------------------------------------------------------------------

# Read by the tmux plugin on init.
ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOCONNECT=false

# The kubectl and docker plugins regenerate completions into
# $ZSH_CACHE_DIR/completions. Unset, that path resolves to
# "/completions/_kubectl" and the =( ... ) temp file substitution fails.
export ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh
[[ -d $ZSH_CACHE_DIR/completions ]] || mkdir -p $ZSH_CACHE_DIR/completions
typeset -U path fpath  # drop duplicate entries

# The docker plugin uses is-at-least for version comparison.
autoload -Uz is-at-least

# The gcloud plugin probes a fixed list of SDK locations to find CLOUDSDK_HOME
# and mise's install path is not one of them, so it never sources
# completion.zsh.inc. Derive it from the gcloud on PATH ($CLOUDSDK_HOME/bin/gcloud)
# with zsh modifiers: :A resolves the symlink, :h:h strips /bin/gcloud.
(( $+commands[gcloud] )) && export CLOUDSDK_HOME=${${commands[gcloud]:A}:h:h}

# Extra completion functions (_sesh, bun's _bun, and whatever the plugins above
# generate) must be in fpath before zim's completion module runs compinit.
# Do NOT add $BUN_INSTALL itself: carapace's zsh bridge recursively scans every
# fpath dir for `_*` files and would crawl ~/.bun/install/cache (16k+ npm files,
# e.g. lodash's _baseConvert.js), injecting garbage like `Number`/`lodash` into
# its generated script. carapace provides bun completion instead.
# $ZSH_CACHE_DIR/completions is also deliberately NOT in fpath: the omz kubectl
# and docker plugins rewrite _kubectl/_docker there in the background on every
# start, which bumps their mtime and forces zim to rerun a full compinit
# (~250 ms) on the next shell. carapace provides kubectl/docker completion anyway.
fpath+=(~/.zsh/completions)

# Syntax highlighting theme (read at highlight time, so order is flexible).
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# ---------------------------------------------------------------------------
# 4. zimfw -- https://github.com/zimfw/zimfw
# ---------------------------------------------------------------------------
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Install missing modules and rebuild init.zsh if it is missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /opt/homebrew/opt/zimfw/share/zimfw.zsh init
fi
source ${ZIM_HOME}/init.zsh
# Prompt: zim agnoster theme (see ~/.zimrc). Requires a Powerline-patched /
# Nerd Font in the terminal for the segment separators.

# Kubernetes segment for agnoster, fed by kube-ps1 (see ~/.zimrc). kube-ps1
# refreshes KUBE_PS1_CONTEXT/NAMESPACE in a precmd hook, and only re-runs
# kubectl when the kubeconfig changes. `kubeoff` / `kubeon` hide/show it.
# gke_<project>_<zone>_<cluster> context names are shortened to <cluster>.
_kube_ps1_short_context() {
  if [[ $1 == gke_*_*_* ]]; then print -r -- ${1##*_}; else print -r -- $1; fi
}
KUBE_PS1_CLUSTER_FUNCTION=_kube_ps1_short_context

# Rendered in the right prompt as a left-pointing powerline segment.
_prompt_agnoster_kube() {
  [[ ${KUBE_PS1_ENABLED} != off && ${_KUBE_PS1_HAS_CONTEXT} == true ]] || return
  local ctx=${KUBE_PS1_CONTEXT//\%/%%} ns=${KUBE_PS1_NAMESPACE//\%/%%}
  local color=cyan
  [[ ${KUBE_PS1_CONTEXT} == *prod* ]] && color=red
  [[ -n ${ns} && ${ns} != N/A && ${ns} != default ]] && ctx+=":${ns}"
  print -n "%F{${color}}%S ⎈ ${ctx} %s%f"
}
RPS1='$(_prompt_agnoster_kube)'

# ---------------------------------------------------------------------------
# 5. Environment
# ---------------------------------------------------------------------------
export EDITOR='nvim'

export MOUNTPOINT=/Volumes/GitLab
export GNUPGHOME=${GNUPGHOME:-$HOME/.gnupg}
# export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
# export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"

# Go
export GOPRIVATE=gitlab.com

# Kubernetes / containers
export K9S_CONFIG_DIR=~/.config/k9s
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export DOCKER_HOST=unix://$HOME/.colima/default/docker.sock
export GITLAB_DOCKER_SOCKET="$HOME/.colima/default/docker.sock"

# Google Cloud / Vertex
export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/application_default_credentials.json
export GOOGLE_CLOUD_PROJECT=vglafirov-bef12636
export VERTEX_LOCATION=global

# Services
export HOMEASSISTANT_URL="https://home.vglafirov.com"
export GRAFANA_URL="https://dashboards.gitlab.net"
export SEARXNG_API_URL="https://search.vglafirov.com/search"
export OLLAMA_HOST=0.0.0.0
export VAULT_PROXY_ADDR="socks5://localhost:18200"

export OPENCODE_EXPERIMENTAL_WORKSPACES=true

# ---------------------------------------------------------------------------
# 6. Aliases
#    The kubectl/git/docker/golang/aws/gcloud/tmux alias sets come from the
#    oh-my-zsh plugins loaded by zim. These are the extras.
# ---------------------------------------------------------------------------
alias ktx="kubectx"
alias kns="kubens"
alias nx='nix-shell --run $SHELL'

alias lg="lazygit"
alias oc="opencode"

alias vim='nvim'
alias v='nvim'

# ---------------------------------------------------------------------------
# 7. Functions
# ---------------------------------------------------------------------------

# Focus an aerospace window via fzf.
ff() {
  aerospace list-windows --all |
    fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

# cd into a directory picked with fzf.
fcd() {
  local dir
  dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
}

# yazi, returning to the directory it exits in.
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Switch gcloud configuration with fzf.
gtx() {
  local config
  config=$(gcloud config configurations list --format="value(name)" |
    fzf --height 40% --reverse --header="Select gcloud configuration")
  [[ -n "$config" ]] || return

  gcloud config configurations activate "$config"
  echo "Switched to configuration: $config"
  echo "Account: $(gcloud config get-value account)"
  echo "Project: $(gcloud config get-value project)"
}

# Switch gcloud account and refresh application-default credentials.
gapp() {
  local config
  config=$(gcloud auth list --format=json | jq -r ".[].account" |
    fzf --height 40% --reverse --header="Select gcloud account")
  [[ -n "$config" ]] || return

  gcloud config set account "$config"
  gcloud auth application-default login
  echo "Switched to account: $config"
}

# 1Password sign-in, then re-evaluate direnv.
login1p() {
  eval "$(op signin --account gitlab.1password.com)"
  direnv reload
}

# Load the usual secrets into the environment.
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

hotline() {
  eval "$(op signin --account my)"
  export HOTLINE_GITLAB_TOKEN=$(op read "op://private/gitlab-hotline-pat/credential")
}

# Point the tooling at a local caproni instance.
selfhosted() {
  export GITLAB_INSTANCE_URL=https://gitlab.caproni.test
  # This instance routes Duo through GitLab's STAGING AI gateway via Cloud
  # Connector. The direct_access token is minted for the staging realm, so the
  # provider must send model/proxy requests to the staging gateway. Without
  # this it defaults to https://cloud.gitlab.com and fails with a connection
  # error ("typo in the url or port?").
  export GITLAB_AI_GATEWAY_URL=https://cloud.staging.gitlab.com
  export NODE_EXTRA_CA_CERTS=$HOME/.local/share/caproni/caproni/pki/ca.crt
  export GITLAB_OAUTH_CLIENT_ID=d20e6bba067cb2b016a0d5998ec3534f0a8bea75a8624fb6513cc40fb0fabf1d
  eval "$(op signin --account my)"
  export GITLAB_TOKEN=$(op read "op://private/gitlab-api-token-self-hosted/credential")
}

# Point the tooling at staging.gitlab.com.
staging() {
  export GITLAB_INSTANCE_URL=https://staging.gitlab.com
  export GITLAB_AI_GATEWAY_URL=https://cloud.staging.gitlab.com
  export GITLAB_OAUTH_CLIENT_ID=63b9b9a0654d6abd8a6e624f38eb42668a92ee16345667b2bf9a394050206e17
  eval "$(op signin --account my)"
  export GITLAB_TOKEN=$(op read "op://private/gitlab-api-token-staging/credential")
}

# Route HTTP(S) through a local mitmproxy.
mproxy() {
  export HTTP_PROXY=http://127.0.0.1:8035
  export HTTPS_PROXY=http://127.0.0.1:8035
  export NODE_EXTRA_CA_CERTS=~/.mitmproxy/mitmproxy-ca-cert.pem
  echo "run: mitmproxy -p 8035"
}

# ---------------------------------------------------------------------------
# 8. Shell integrations
#    These hook into the line editor or the completion system, so they come
#    after zim's compinit.
# ---------------------------------------------------------------------------
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.config/op/plugins.sh ]] && source ~/.config/op/plugins.sh

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# gcloud completion (its PATH entry is set in section 2).
[[ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]] && . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
