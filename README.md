# 🚀 Scripts Shell - Configuration WSL Dev Environment

Collection de scripts shell pour automatiser la configuration d'un environnement de développement complet sur WSL (Windows Subsystem for Linux).

## 📋 Vue d'ensemble

Ce projet contient des scripts pour configurer rapidement un environnement de développement optimisé avec :
- **Zsh** avec Oh My Zsh et Powerlevel10k
- **PHP** (multi-versions 8.3, 8.4, 8.5) avec Composer
- **Node.js** avec NVM, pnpm et yarn
- **Python** avec pipenv et pipx
- **Outils de développement** : Docker, Redis, PostgreSQL
- **Plugins Zsh** optimisés pour la productivité

## 🛠️ Scripts disponibles

### 1. `setup.sh` - Installation complète
Script principal qui installe et configure tout l'environnement de développement.

**Fonctionnalités :**
- Mise à jour du système Ubuntu
- Installation de Zsh + Oh My Zsh + Powerlevel10k
- Installation de PHP multi-versions (8.3, 8.4, 8.5)
- Configuration de Composer
- Installation de Node.js via NVM
- Installation de pnpm et yarn
- Configuration de Python avec pipenv
- Installation d'outils additionnels (Redis, PostgreSQL client)
- Configuration des alias et variables d'environnement

### 2. `setup-wsl-zsh.sh` - Configuration Zsh optimisée
Configure Zsh avec une configuration complète et des plugins optimisés.

**Fonctionnalités :**
- Configuration Oh My Zsh avec plugins essentiels
- Installation de plugins additionnels (zsh-autosuggestions, zsh-syntax-highlighting, etc.)
- Alias pour Laravel, Docker, Git, Python
- Configuration des variables d'environnement
- Optimisation des performances avec zsh-defer

### 3. `install-zsh-plugins.sh` - Installation des plugins Zsh
Installe uniquement les plugins Zsh recommandés.

**Plugins installés :**
- `zsh-defer` - Chargement différé pour de meilleures performances
- `zsh-autosuggestions` - Suggestions automatiques
- `zsh-syntax-highlighting` - Coloration syntaxique
- `zsh-completions` - Completions avancées
- `zsh-history-substring-search` - Recherche dans l'historique
- `you-should-use` - Suggestions d'alias
- `zsh-bat` - Support pour bat (cat amélioré)
- `zoxide` - Navigation intelligente

### 4. `update-zsh-config.sh` - Mise à jour de la configuration Zsh
Met à jour la configuration Zsh existante avec la dernière version optimisée.

## 🚀 Installation et utilisation

### Installation complète (recommandée)
```bash
# Cloner le repository
git clone <votre-repo> scripts-shell
cd scripts-shell

# Rendre les scripts exécutables
chmod +x *.sh

# Exécuter l'installation complète
./setup.sh
```

### Installation par étapes
```bash
# 1. Installation de base
./setup.sh

# 2. Installation des plugins Zsh
./install-zsh-plugins.sh

# 3. Configuration Zsh optimisée
./setup-wsl-zsh.sh

# 4. Mise à jour de la configuration (optionnel)
./update-zsh-config.sh
```

## ⚙️ Configuration après installation

### Recharger la configuration
```bash
source ~/.zshrc
```

### Changer de version PHP
```bash
phpswitch  # ou php81, php84, php85
```

### Vérifier les installations
```bash
php -v
node -v
python3 --version
composer --version
```

## 🎯 Alias disponibles

### Laravel
- `art` ou `a` - php artisan
- `a_serve` - php artisan serve
- `a_tinker` - php artisan tinker
- `a_migrate` - php artisan migrate --seed
- `a_fresh` - php artisan migrate:fresh --seed

### Livewire
- `palw` - php artisan livewire
- `palwl` - php artisan livewire:list
- `pamlw` - php artisan make:livewire

### Filament
- `pafil` - php artisan filament
- `pamfil` - php artisan make:filament-resource
- `pamfilu` - php artisan make:filament-user

### Docker
- `dps` - docker ps (format table)
- `dstop` - docker stop (tous les conteneurs)
- `drm` - docker rm (tous les conteneurs)
- `dclean` - docker system prune
- `dup` - docker compose up -d
- `ddown` - docker compose down

### Git
- `gst` - git status
- `gcm` - git commit -m
- `gco` - git checkout
- `gpull` - git pull origin (branche actuelle)
- `gpush` - git push origin (branche actuelle)
- `gnew` - git checkout -b

### Python
- `pv` - pipenv run
- `pvi` - pipenv install
- `pvs` - pipenv shell

### Navigation
- `cdcode` - cd ~/codes
- `cds` - cd ~/codes

## 🔧 Personnalisation

### Modifier les alias
Éditez le fichier `~/.zshrc` pour ajouter vos propres alias.

### Ajouter des plugins
Modifiez la section `plugins=()` dans `~/.zshrc`.

### Changer le thème
Modifiez la variable `ZSH_THEME` dans `~/.zshrc`.

## 📁 Structure du projet

```
scripts-shell/
├── setup.sh                 # Installation complète
├── setup-wsl-zsh.sh         # Configuration Zsh optimisée
├── install-zsh-plugins.sh   # Installation des plugins
├── update-zsh-config.sh     # Mise à jour de la configuration
└── README.md                # Ce fichier
```

## 🐛 Dépannage

### Problèmes courants

1. **Zsh n'est pas le shell par défaut**
   ```bash
   chsh -s $(which zsh)
   ```

2. **Oh My Zsh n'est pas installé**
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. **Plugins ne se chargent pas**
   ```bash
   source ~/.zshrc
   ```

4. **PHP alternatives non configurées**
   ```bash
   sudo update-alternatives --config php
   ```

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Ouvrir une issue pour signaler un bug
- Proposer de nouveaux alias ou plugins
- Améliorer la documentation

## 📝 Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## 🎉 Crédits

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [NVM](https://github.com/nvm-sh/nvm)
- [Composer](https://getcomposer.org/)

---

**Happy coding ! 🚀**
