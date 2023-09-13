#!/bin/bash
set -e

(>&2 echo "[*] Bootstrap PHP")

if [ ! -s "/etc/php/$PHP_VERSION/90-php.ini" ]; then
# on récupère toutes les variables d'env qui commencent par PHP_
  for e in "${!PHP_@}"; do

    if [ "$e" != "PHP_VERSION" ]; then
#  on enleve le PHP_ on rempalce le __ par . et change la casse en minuscule
      VARIABLE=$(echo "$e" \
          | sed -e 's/PHP_/''/g' \
          | sed -e 's/__/'.'/g' \
          | awk '{print tolower($0)}')

      VALUE=$(printenv "$e")
# on rajoute ces valeurs dans le fichier 90-php.ini
      echo "$VARIABLE = '$VALUE'" >> "/etc/php/$PHP_VERSION/90-php.ini"

    fi

  done

fi
