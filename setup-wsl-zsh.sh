#!/usr/bin/env bash
set -e

ZSHRC="$HOME/.zshrc"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

echo "🧩 Installation des plugins Zsh..."

# Vérifie si Oh My Zsh est installé
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🚨 Oh My Zsh n'est pas installé. Installe-le d'abord avec :"
    echo 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    exit 1
fi

# Fonction d'installation générique
install_plugin() {
    local name=$1
    local url=$2
    local dir="$ZSH_CUSTOM/$name"
    if [ ! -d "$dir" ]; then
        git clone "$url" "$dir"
        echo "✅ $name installé"
    else
        echo "🔁 $name déjà installé"
    fi
}

# Plugins principaux
install_plugin "zsh-defer" "https://github.com/romkatv/zsh-defer.git"
install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
install_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions"
install_plugin "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search"
install_plugin "you-should-use" "https://github.com/MichaelAquilina/zsh-you-should-use.git"
install_plugin "zsh-bat" "https://github.com/fdellwing/zsh-bat.git"
install_plugin "zoxide" "https://github.com/ajeetdsouza/zoxide.git"

echo "🎉 Plugins installés !"

TMP_BLOCK=$(mktemp)

# ==========================================
# 1️⃣ Contenu complet du bloc Zsh
# ==========================================
cat > "$TMP_BLOCK" <<'EOF'
# ================================================
# ⚙️ CONFIGURATION ZSH OPTIMISÉE (WSL Dev Setup)
# ================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
CASE_SENSITIVE="false"

plugins=(
  alias-finder
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
)

source $ZSH/oh-my-zsh.sh

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

zsh-defer source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
zsh-defer source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zsh-defer source $ZSH_CUSTOM/plugins/zsh-completions/zsh-completions.plugin.zsh 2>/dev/null
zsh-defer source $ZSH_CUSTOM/plugins/zoxide/zoxide.zsh 2>/dev/null
zsh-defer source $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null

export PROMPT='%F{cyan}%n@%m%f %F{yellow}%1~%f $(git_prompt_info)%# '

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias php81='sudo update-alternatives --set php /usr/bin/php8.1 && php -v'
alias php84='sudo update-alternatives --set php /usr/bin/php8.4 && php -v'
alias php85='sudo update-alternatives --set php /usr/bin/php8.5 && php -v'
alias composer-update='composer self-update && composer update'

alias npmi='npm install'
alias npmr='npm run'
alias dev='npm run dev || yarn dev'

alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias dclean='docker system prune -af --volumes'
alias dup='docker compose up -d'
alias ddown='docker compose down'

alias art='php artisan'
alias a='php artisan'
alias a_serve='php artisan serve'
alias a_tinker='php artisan tinker'
alias a_migrate='php artisan migrate --seed'
alias a_fresh='php artisan migrate:fresh --seed'

alias palw='php artisan livewire'
alias palwl='php artisan livewire:list'
alias pamlw='php artisan make:livewire'

alias pafil='php artisan filament'
alias pamfil='php artisan make:filament-resource'
alias pamfilu='php artisan make:filament-user'

alias gst='git status'
alias gcm='git commit -m'
alias gco='git checkout'
alias gpull='git pull origin $(git branch --show-current)'
alias gpush='git push origin $(git branch --show-current)'
alias gnew='git checkout -b'

export PIPENV_VENV_IN_PROJECT=1
alias pv='pipenv run'
alias pvi='pipenv install'
alias pvs='pipenv shell'

if command -v pyenv 1>/dev/null 2>&1; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

export CODES="/mnt/d/codes"
alias cdcode='cd $CODES'

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
export NO_AT_BRIDGE=1

echo -e "\n🚀 Zsh configuré avec succès ! Happy coding 🎉"
EOF

# ==========================================
# 2️⃣ Remplacement du bloc existant ou ajout
# ==========================================
if grep -q "CONFIGURATION ZSH OPTIMISÉE" "$ZSHRC"; then
    echo "🔁 Bloc existant trouvé, remplacement..."
    # Supprime l'ancien bloc et insère le nouveau
    awk '
    BEGIN {flag=0}
    /CONFIGURATION ZSH OPTIMISÉE/ {flag=1; print ""} 
    /# 🚀 Zsh configuré/ {flag=0; next} 
    !flag {print}
    ' "$ZSHRC" > "${ZSHRC}.tmp"
    cat "$TMP_BLOCK" >> "${ZSHRC}.tmp"
    mv "${ZSHRC}.tmp" "$ZSHRC"
else
    echo "➕ Ajout du bloc Zsh optimisé à la fin..."
    cat "$TMP_BLOCK" >> "$ZSHRC"
fi

rm "$TMP_BLOCK"
echo "✅ Bloc ajouté ou mis à jour ! Recharge ton shell : source ~/.zshrc"