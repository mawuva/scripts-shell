#!/usr/bin/env bash
set -e

echo "🚀 Configuration VPS Ubuntu - Environnement de développement complet"
echo "=================================================================="

# ==========================================
# 1️⃣ EXÉCUTION DU SETUP DE BASE
# ==========================================
echo ""
echo "📦 Étape 1/3 : Installation de base du système..."
echo "================================================"

# Vérifier si setup.sh existe et l'exécuter
if [ -f "./setup.sh" ]; then
    echo "🔄 Exécution de setup.sh..."
    chmod +x ./setup.sh
    ./setup.sh
    echo "✅ Setup de base terminé"
else
    echo "⚠️  setup.sh non trouvé, installation manuelle des dépendances..."
    
    # Installation manuelle des dépendances de base
    echo "💻 Installation des dépendances de base..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y build-essential curl wget git zip unzip software-properties-common ca-certificates lsb-release gnupg zsh
    
    # Installation de Oh My Zsh si pas déjà installé
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "🎨 Installation de Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Installation de Powerlevel10k
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "✨ Installation du thème Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
fi

# ==========================================
# 2️⃣ INSTALLATION DES PLUGINS ZSH
# ==========================================
echo ""
echo "🧩 Étape 2/3 : Installation des plugins Zsh..."
echo "============================================="

# Vérifier si install-zsh-plugins.sh existe et l'exécuter
if [ -f "./install-zsh-plugins.sh" ]; then
    echo "🔄 Exécution de install-zsh-plugins.sh..."
    chmod +x ./install-zsh-plugins.sh
    ./install-zsh-plugins.sh
    echo "✅ Plugins Zsh installés"
else
    echo "⚠️  install-zsh-plugins.sh non trouvé, installation manuelle des plugins..."
    
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    
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
    
    # Installation des plugins
    install_plugin "zsh-defer" "https://github.com/romkatv/zsh-defer.git"
    install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
    install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
    install_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions"
    install_plugin "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search"
    install_plugin "you-should-use" "https://github.com/MichaelAquilina/zsh-you-should-use.git"
    install_plugin "zsh-bat" "https://github.com/fdellwing/zsh-bat.git"
    install_plugin "zoxide" "https://github.com/ajeetdsouza/zoxide.git"
    
    echo "✅ Plugins Zsh installés manuellement"
fi

# ==========================================
# 3️⃣ CONFIGURATION ZSH OPTIMISÉE POUR VPS
# ==========================================
echo ""
echo "⚙️ Étape 3/3 : Configuration Zsh optimisée pour VPS..."
echo "===================================================="

ZSHRC="$HOME/.zshrc"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

echo "🧩 Configuration des plugins Zsh..."

# Vérifie si Oh My Zsh est installé
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🚨 Oh My Zsh n'est pas installé. Installe-le d'abord avec :"
    echo 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    exit 1
fi

TMP_BLOCK=$(mktemp)

# ==========================================
# CONFIGURATION COMPLÈTE DU BLOC ZSH POUR VPS
# ==========================================
cat > "$TMP_BLOCK" <<'EOF'
# ================================================
# ⚙️ CONFIGURATION ZSH OPTIMISÉE (VPS Ubuntu)
# ================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
CASE_SENSITIVE="false"

plugins=(
  aliases
  command-not-found
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

# ==========================================
# 🏠 CHEMINS ADAPTÉS POUR VPS UBUNTU
# ==========================================
export CODES="$HOME/codes"
alias cdcode='cd $CODES'

# Créer le répertoire codes s'il n'existe pas
if [ ! -d "$CODES" ]; then
    mkdir -p "$CODES"
    echo "📁 Répertoire $CODES créé"
fi

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
export NO_AT_BRIDGE=1

# ==========================================
# 🐳 ALIAS DOCKER OPTIMISÉS POUR VPS
# ==========================================
alias d='docker'
alias dc='docker compose'
alias dpsa='docker ps -a'
alias dlogs='docker logs'
alias dexec='docker exec -it'
alias drestart='docker restart'
alias dstart='docker start'
alias dstop='docker stop'

# ==========================================
# 🐘 ALIAS PHP OPTIMISÉS POUR VPS
# ==========================================
alias phpswitch='sudo update-alternatives --config php'
alias c='composer'
alias ci='composer install'
alias cu='composer update'
alias cda='composer dump-autoload'
alias cdao='composer dump-autoload --optimize'

# ==========================================
# 🟩 ALIAS NODE/NPM OPTIMISÉS POUR VPS
# ==========================================
alias p='pnpm'
alias pi='pnpm install'
alias pu='pnpm update'
alias pr='pnpm run'
alias pd='pnpm run dev'
alias pb='pnpm run build'
alias pt='pnpm run test'

# ==========================================
# 🐍 ALIAS PYTHON OPTIMISÉS POUR VPS
# ==========================================
alias py='python3'
alias pip='pip3'
alias pyshell='pipenv shell'
alias pyenv='pipenv run python'
alias pyinstall='pipenv install'
alias pydev='pipenv install --dev'

# ==========================================
# 📁 ALIAS NAVIGATION OPTIMISÉS POUR VPS
# ==========================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cds='cd ~/codes'
alias cdh='cd ~'
alias cdt='cd /tmp'

# ==========================================
# 🔧 ALIAS SYSTÈME OPTIMISÉS POUR VPS
# ==========================================
alias top='htop'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ==========================================
# 🚀 ALIAS DÉVELOPPEMENT OPTIMISÉS POUR VPS
# ==========================================
alias serve='php artisan serve --host=0.0.0.0 --port=8000'
alias serve80='php artisan serve --host=0.0.0.0 --port=80'
alias serve443='php artisan serve --host=0.0.0.0 --port=443'
alias logs='tail -f storage/logs/laravel.log'
alias clear-logs='> storage/logs/laravel.log'

echo -e "\n🚀 Zsh configuré avec succès pour VPS Ubuntu ! Happy coding 🎉"
EOF

# ==========================================
# REMPLACEMENT DU BLOC EXISTANT OU AJOUT
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

# ==========================================
# 🎯 FINALISATION
# ==========================================
echo ""
echo "🎉 Configuration VPS terminée avec succès !"
echo "=========================================="
echo ""
echo "📋 Résumé des installations :"
echo "✅ Système de base (Ubuntu packages)"
echo "✅ Zsh + Oh My Zsh + Powerlevel10k"
echo "✅ Plugins Zsh optimisés"
echo "✅ Configuration Zsh complète pour VPS"
echo "✅ Alias de développement optimisés"
echo "✅ Répertoire ~/codes créé"
echo ""
echo "🔄 Pour appliquer les changements :"
echo "   source ~/.zshrc"
echo ""
echo "🚀 Commandes utiles :"
echo "   cdcode    # Aller dans ~/codes"
echo "   phpswitch # Changer de version PHP"
echo "   serve     # Démarrer Laravel sur 0.0.0.0:8000"
echo "   d         # Docker"
echo "   dc        # Docker Compose"
echo ""
echo "Happy coding sur votre VPS ! 🎉"
