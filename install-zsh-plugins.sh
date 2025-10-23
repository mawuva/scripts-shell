#!/usr/bin/env bash

# ===============================================
# ⚡ INSTALLATION DES PLUGINS ZSH (pour WSL)
# ===============================================

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

echo "🧩 Installation des plugins Zsh..."

# Vérifie si Oh My Zsh est installé
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🚨 Oh My Zsh n'est pas installé. Installe-le d'abord avec :"
  echo "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
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

# Nouveau plugin: zoxide
install_plugin "zoxide" "https://github.com/ajeetdsouza/zoxide.git"

echo "🎉 Installation terminée !"
echo "🧠 N'oublie pas d’ajouter ceci dans ton ~/.zshrc :"

cat <<'EOF'

# =========================
# ⚙️ Plugins additionnels
# =========================
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Charge les plugins en différé pour plus de vitesse
source $ZSH_CUSTOM/plugins/zsh-defer/zsh-defer.plugin.zsh

zsh-defer source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
zsh-defer source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zsh-defer source $ZSH_CUSTOM/plugins/zsh-completions/zsh-completions.plugin.zsh 2>/dev/null
zsh-defer source $ZSH_CUSTOM/plugins/zoxide/zoxide.zsh 2>/dev/null

EOF

echo "👉 Puis exécute : source ~/.zshrc"
