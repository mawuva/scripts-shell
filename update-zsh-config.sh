#!/usr/bin/env bash
set -e

ZSHRC="$HOME/.zshrc"

# Le contenu complet à insérer ou mettre à jour
read -r -d '' NEW_BLOCK <<'EOF'
# ================================================
# ⚙️ CONFIGURATION ZSH OPTIMISÉE (WSL Dev Setup)
# ================================================

# ---------------------------
# 🧩 Oh My Zsh Base
# ---------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"   # (ou "powerlevel10k" si installé)
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
CASE_SENSITIVE="false"

# Plugins
plugins=(*
  aliases
  alias-finder
  command-not-found
  git
  docker
  docker-compose
  composer
  flutter
  history
  laravel
  node
  npm
  nvm
  pip
  pipenv
  poetry
  python
  redis-cli
  you-should-use
  zsh-defer
  zsh-bat
  zoxide
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

# ---------------------------
# ⚡ Plugins additionnels
# ---------------------------
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Auto-suggestions & syntax highlighting
zsh-defer source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
zsh-defer source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zsh-defer source $ZSH_CUSTOM/plugins/zsh-completions/zsh-completions.plugin.zsh 2>/dev/null
zsh-defer source $ZSH_CUSTOM/plugins/zoxide/zoxide.zsh 2>/dev/null
zsh-defer source $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null

# ---------------------------
# 🎨 Appearance
# ---------------------------
export PROMPT='%F{cyan}%n@%m%f %F{yellow}%1~%f $(git_prompt_info)%# '

# Optional Powerlevel10k (si installé)
# source ~/.p10k.zsh

# Couleurs ls
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# ---------------------------
# 🧰 DEV ALIASES
# ---------------------------
# PHP
alias php81='sudo update-alternatives --set php /usr/bin/php8.1 && php -v'
alias php84='sudo update-alternatives --set php /usr/bin/php8.4 && php -v'
alias php85='sudo update-alternatives --set php /usr/bin/php8.5 && php -v'
alias composer-update='composer self-update && composer update'

# Node
alias npmi='npm install'
alias npmr='npm run'
alias dev='npm run dev || yarn dev'

# Docker
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias dclean='docker system prune -af --volumes'
alias dup='docker compose up -d'
alias ddown='docker compose down'

# Laravel
alias art='php artisan'
alias a='php artisan'
alias a_serve='php artisan serve'
alias a_tinker='php artisan tinker'
alias a_migrate='php artisan migrate --seed'
alias a_fresh='php artisan migrate:fresh --seed'

# Livewire
alias palw='php artisan livewire'
alias palwl='php artisan livewire:list'
alias pamlw='php artisan make:livewire'

# Filament
alias pafil='php artisan filament'
alias pamfil='php artisan make:filament-resource'
alias pamfilu='php artisan make:filament-user'

# Git
alias gst='git status'
alias gcm='git commit -m'
alias gco='git checkout'
alias gpull='git pull origin $(git branch --show-current)'
alias gpush='git push origin $(git branch --show-current)'
alias gnew='git checkout -b'

# Python & Pipenv
export PIPENV_VENV_IN_PROJECT=1
alias pv='pipenv run'
alias pvi='pipenv install'
alias pvs='pipenv shell'

if command -v pyenv 1>/dev/null 2>&1; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Paths custom
export CODES="/mnt/d/codes"
alias cdcode='cd $CODES'

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
export NO_AT_BRIDGE=1

# ---------------------------
# ✅ Fin de configuration
# ---------------------------
echo -e "\n🚀 Zsh configuré avec succès ! Happy coding 🎉"
EOF

# ---------------------------
# 🔧 Mise à jour du .zshrc avec sed
# ---------------------------
if grep -q "CONFIGURATION ZSH OPTIMISÉE" "$ZSHRC"; then
    echo "🔁 Bloc existant trouvé, mise à jour en place..."
    sed -i.bak "/CONFIGURATION ZSH OPTIMISÉE/,/# ✅ Fin de configuration/c\\
$NEW_BLOCK
" "$ZSHRC"
else
    echo "➕ Ajout du bloc Zsh optimisé à la fin..."
    echo "$NEW_BLOCK" >> "$ZSHRC"
fi

echo "✅ Bloc ajouté ou mis à jour avec succès ! Recharge ton shell : source ~/.zshrc"
