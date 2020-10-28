#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

echo ====
echo "INFO: May take a while, to skip press CTRL-C"
echo ====

function ctrl_c() {
    echo
    echo "WARNING: Page may not be ready"
    echo "Exiting..."
    exit 0
}

until wget http://angular:4200/
do
  echo "

  Pagina no disponible, compilando...
  Intentando dentro de 2s. Ctrl+C para cancelar espera.

  "
  sleep 2
done

echo -------------
echo Page ready. SUCCESS
echo -------------
exit 0