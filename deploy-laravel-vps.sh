#!/bin/bash
set -e  # stop on error

# ==========================================
# 🚀 SCRIPT DE DÉPLOIEMENT LARAVEL VPS AMÉLIORÉ
# ==========================================

# Vérifier le nombre d'arguments
if [ $# -lt 3 ]; then
    echo "Usage : $0 <dépôt_git> <branche> <dossier_deploy> [php_version]"
    echo
    echo "Arguments :"
    echo "  dépôt_git      : URL SSH ou HTTPS de votre dépôt Git (ex: git@github.com:user/projet.git)"
    echo "  branche        : branche à déployer (ex: main ou develop)"
    echo "  dossier_deploy : dossier sur le serveur où le projet sera déployé (ex: mon-projet)"
    echo "  php_version    : (optionnel) version de PHP à utiliser (ex: 8.4). Si non précisé, la version par défaut sera utilisée"
    echo
    echo "Exemples :"
    echo "  $0 git@github.com:user/projet.git main mon-projet"
    echo "  $0 git@github.com:user/projet.git main mon-projet 8.4"
    exit 1
fi

REPO="$1"
BRANCH="$2"
PROJECT_DIR="/var/www/$3"
PHP_VERSION="${4:-default}"
BACKUP_DIR="/var/backups/laravel-deployments"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "🚀 Déploiement de $REPO sur la branche $BRANCH dans $PROJECT_DIR"

# ==========================================
# 🔍 VÉRIFICATIONS PRÉALABLES
# ==========================================
echo "🔍 Vérification des prérequis..."

# Vérifier les commandes nécessaires
for cmd in git composer npm php; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ $cmd n'est pas installé"
        exit 1
    fi
done

# Vérifier les permissions
if [ ! -w "/var/www" ]; then
    echo "❌ Pas de permissions d'écriture sur /var/www"
    echo "💡 Exécutez : sudo chown -R \$USER:\$USER /var/www"
    exit 1
fi

# ==========================================
# 🐘 CONFIGURATION PHP
# ==========================================
if [ "$PHP_VERSION" != "default" ]; then
    echo "🐘 Utilisation de PHP $PHP_VERSION"
    if ! sudo update-alternatives --set php /usr/bin/php$PHP_VERSION; then
        echo "❌ Impossible de changer vers PHP $PHP_VERSION"
        exit 1
    fi
fi

# Afficher la version de PHP utilisée
echo "📋 Version PHP utilisée :"
php -v

# ==========================================
# 💾 BACKUP PRÉALABLE
# ==========================================
if [ -d "$PROJECT_DIR" ] && [ -d "$PROJECT_DIR/.git" ]; then
    echo "💾 Création d'un backup..."
    mkdir -p "$BACKUP_DIR"
    sudo cp -r "$PROJECT_DIR" "$BACKUP_DIR/backup_$3_$TIMESTAMP"
    echo "✅ Backup créé : $BACKUP_DIR/backup_$3_$TIMESTAMP"
fi

# ==========================================
# 📁 PRÉPARATION DU RÉPERTOIRE
# ==========================================
echo "📁 Préparation du répertoire..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# ==========================================
# 🔄 GESTION DU DÉPÔT GIT
# ==========================================
if [ ! -d ".git" ]; then
    echo "📥 Clonage du dépôt..."
    git clone -b "$BRANCH" "$REPO" .
else
    echo "🔄 Mise à jour du dépôt..."
    git fetch --all
    git reset --hard "origin/$BRANCH"
    git clean -fd
fi

# Vérifier que le clone/update a réussi
if [ ! -f "composer.json" ]; then
    echo "❌ composer.json non trouvé. Vérifiez l'URL du dépôt et la branche."
    exit 1
fi

# ==========================================
# 📦 INSTALLATION DES DÉPENDANCES
# ==========================================
echo "📦 Installation des dépendances PHP..."
composer install --no-dev --optimize-autoloader --no-interaction

echo "📦 Installation des dépendances Node.js..."
if [ -f "package.json" ]; then
    npm ci --production
    npm run build
else
    echo "⚠️  package.json non trouvé, étape Node.js ignorée"
fi

# ==========================================
# ⚙️ CONFIGURATION LARAVEL
# ==========================================
echo "⚙️ Configuration Laravel..."

# Vérifier si .env existe
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo "📋 Copie de .env.example vers .env..."
        cp .env.example .env
        echo "⚠️  N'oubliez pas de configurer votre fichier .env !"
    else
        echo "❌ Aucun fichier .env trouvé. Créez-en un manuellement."
        exit 1
    fi
fi

# Générer la clé d'application si nécessaire
if ! grep -q "APP_KEY=" .env || grep -q "APP_KEY=$" .env; then
    echo "🔑 Génération de la clé d'application..."
    php artisan key:generate
fi

# ==========================================
# 🗄️ GESTION DE LA BASE DE DONNÉES
# ==========================================
echo "🗄️ Gestion de la base de données..."

# Vérifier la connexion à la base de données
if php artisan migrate:status &> /dev/null; then
    echo "✅ Connexion à la base de données OK"
    echo "🔄 Exécution des migrations..."
    php artisan migrate --force
else
    echo "⚠️  Impossible de se connecter à la base de données"
    echo "💡 Vérifiez votre configuration .env (DB_*)"
fi

# ==========================================
# 🚀 OPTIMISATIONS LARAVEL
# ==========================================
echo "🚀 Optimisations Laravel..."

# Clear et cache
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Cache pour la production
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Redémarrer les queues
php artisan queue:restart

# ==========================================
# 🔐 PERMISSIONS
# ==========================================
echo "🔐 Configuration des permissions..."

# Permissions pour Laravel
sudo chown -R www-data:www-data storage bootstrap/cache
sudo chmod -R 775 storage bootstrap/cache

# ==========================================
# ✅ FINALISATION
# ==========================================
echo ""
echo "🎉 Déploiement terminé avec succès !"
echo "=================================="
echo ""
echo "📋 Résumé :"
echo "✅ Dépôt cloné/mis à jour : $REPO ($BRANCH)"
echo "✅ Dépendances installées"
echo "✅ Base de données migrée"
echo "✅ Cache optimisé"
echo "✅ Permissions configurées"
echo ""
echo "🔧 Prochaines étapes :"
echo "1. Configurez votre fichier .env"
echo "2. Configurez votre serveur web (Nginx/Apache)"
echo "3. Testez votre application"
echo ""
echo "📁 Projet déployé dans : $PROJECT_DIR"
if [ -d "$BACKUP_DIR/backup_$3_$TIMESTAMP" ]; then
    echo "💾 Backup disponible : $BACKUP_DIR/backup_$3_$TIMESTAMP"
fi
