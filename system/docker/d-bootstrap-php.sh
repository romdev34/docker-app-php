#!/bin/bash
set -e

(>&2 echo "[*] Bootstrap PHP")

# Action : Teste si le fichier de configuration n'existe pas OU est vide
# -s : Teste si le fichier existe et n'est pas vide
# ! : Négation - donc exécute le bloc si le fichier n'existe pas ou est vide
if [ ! -s "/etc/php/$PHP_VERSION/90-php.ini" ]; then

# Il parcourt toutes les variables d'environnement qui commencent par PHP_.
# L'expansion ${!PHP_@} récupère les noms de toutes ces variables.
  for e in "${!PHP_@}"; do

# Il ignore la variable PHP_VERSION
    if [ "$e" != "PHP_VERSION" ]; then

# Il transforme le nom de la variable :
# Supprime le préfixe PHP_
# Remplace les doubles underscores __ par des points .
# Convertit en minuscules
# Par exemple : PHP_UPLOAD__MAX_FILESIZE devient upload.max_filesize

      VARIABLE=$(echo "$e" \
          | sed -e 's/PHP_/''/g' \
          | sed -e 's/__/'.'/g' \
          | awk '{print tolower($0)}')

# Il récupère la valeur de la variable d'environnement et l'écrit dans le fichier de configuration PHP au format directive = 'valeur'.
# Objectif :
# Ce script permet de configurer PHP via des variables d'environnement dans un conteneur Docker,
# en convertissant automatiquement les variables comme PHP_MEMORY_LIMIT=256M en directives PHP comme memory_limit = '256M'.
      VALUE=$(printenv "$e")
      echo "$VARIABLE = '$VALUE'" >> "/etc/php/$PHP_VERSION/90-php.ini"

    fi

  done

fi
