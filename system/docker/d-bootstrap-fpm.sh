#!/bin/bash
set -e

(>&2 echo "[*] Bootstrap FPM")

# Action : Construit le chemin vers les fichiers de configuration PHP-FPM
# Logique : Utilise la variable $PHP_VERSION pour cibler la bonne version de PHP
# Exemples :
#
# Si PHP_VERSION=8.1 → /etc/php/8.1/fpm
# Si PHP_VERSION=8.2 → /etc/php/8.2/fpm
directory="/etc/php/$PHP_VERSION/fpm"

# Action : Pour chaque fichier .conf trouvé dans le répertoire PHP-FPM :
# Parcourt toutes les variables d'environnement commençant par FPM_
# Remplace les placeholders __VARIABLE__ par leurs valeurs (où VARIABLE est la variable d'environnement)
while IFS= read -r file; do
  for e in "${!FPM_@}"; do

      sed -i -e 's/__'"$e"'__/'"$(printenv "$e")"'/g' "$file"

  done

done < <(find "$directory" -name "*.conf")
