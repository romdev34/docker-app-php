#!/bin/bash
set -e

(>&2 echo "[*] Bootstrap FPM")

directory="/etc/php/$PHP_VERSION/fpm"

while IFS= read -r file; do
# on rajoute __ avant et apres chaque variable env commencant par FPM puis pour ces variables dans les fichiers fpm/*.conf on les remplacent par leur valeur
  for e in "${!FPM_@}"; do

      sed -i -e 's/__'"$e"'__/'"$(printenv "$e")"'/g' "$file"

  done

done < <(find "$directory" -name "*.conf")
