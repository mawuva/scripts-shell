#!/usr/bin/env bash
set -e

echo "🚀 Initialisation du setup WSL pour dev Laravel + JS + Python..."

# --- Mise à jour du système ---
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential curl wget git zip unzip software-properties-common ca-certificates lsb-release gnupg

# --- ZSH & Oh My Zsh ---
if ! command -v zsh &>/dev/null; then
  echo "💻 Installation de Zsh..."
  sudo apt install -y zsh
  chsh -s $(which zsh)
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🎨 Installation de Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Thème Powerlevel10k ---
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "✨ Installation du thème Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
fi

# --- PHP Multi-versions ---
echo "🐘 Installation de PHP 8.3, 8.4 et 8.5..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

for ver in 8.3 8.4 8.5; do
  echo "➡️ Installation PHP $ver"
  sudo apt install -y php$ver php$ver-cli php$ver-common php$ver-mbstring php$ver-xml php$ver-bcmath php$ver-curl php$ver-zip php$ver-intl php$ver-mysql php$ver-sqlite3 php$ver-gd php$ver-dom php$ver-readline
done

# --- Configurer les alternatives pour PHP ---
echo "⚙️ Configuration des alternatives PHP..."
sudo update-alternatives --install /usr/bin/php php /usr/bin/php8.3 83
sudo update-alternatives --install /usr/bin/php php /usr/bin/php8.4 84
sudo update-alternatives --install /usr/bin/php php /usr/bin/php8.5 85
sudo update-alternatives --set php /usr/bin/php8.3

# --- Composer ---
if ! command -v composer &>/dev/null; then
  echo "🎼 Installation de Composer..."
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer
  rm composer-setup.php
fi

# --- Node.js & NVM ---
if [ ! -d "$HOME/.nvm" ]; then
  echo "🟩 Installation de NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm alias default 'lts/*'
else
  echo "🟩 NVM déjà installé, mise à jour possible manuellement."
fi

# --- PNPM ---
echo "📦 Installation de pnpm..."
npm install -g pnpm

# --- Python + Pipenv ---
echo "🐍 Installation de Python et des outils..."
sudo apt install -y python3 python3-pip python3-venv pipx

# --- Configuration Python ---
echo "🐍 Configuration de Python..."
export PIP_BREAK_SYSTEM_PACKAGES=1  # Permet installations globales si nécessaires
pipx ensurepath

echo "📦 Installation de Pipenv via pipx..."
pipx install --include-deps pipenv

# --- Outils additionnels ---
echo "🧰 Installation de Redis, PostgreSQL client, Yarn..."
sudo apt install -y redis postgresql-client
npm install -g yarn

# --- Répertoire de travail ---
if [ ! -d "$HOME/codes" ]; then
  mkdir -p "$HOME/codes"
fi

# --- Alias & PATH ---
echo "⚙️ Configuration de .zshrc..."
{
  echo ""
  echo "# --- Custom Laravel/Node/Python setup ---"
  echo "export NVM_DIR=\"\$HOME/.nvm\""
  echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\""
  echo "export PATH=\"\$HOME/.config/composer/vendor/bin:\$PATH\""
  echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo "alias art='php artisan'"
  echo "alias sail='./vendor/bin/sail'"
  echo "alias p='pnpm'"
  echo "alias c='composer'"
  echo "alias d='docker'"
  echo "alias dc='docker compose'"
  echo "alias pyshell='pipenv shell'"
  echo "alias pyenv='pipenv run python'"
  echo "alias cds='cd ~/codes'"
  echo "alias phpswitch='sudo update-alternatives --config php'"
} >> ~/.zshrc

echo ""
echo "✅ Setup terminé avec succès !"
echo "➡️ Ouvre un nouveau terminal ou exécute : source ~/.zshrc"
echo "➡️ Pour changer de version PHP : phpswitch"
echo "➡️ Pour créer un venv Python : pipenv install"
