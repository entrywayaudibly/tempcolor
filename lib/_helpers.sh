#!/bin/bash
#
# Executes streamlink

function store_temperature() {
  
  local temperature
  temperature=$1

  touch $CONFIG_PATH

  cat << EOF > "${CONFIG_PATH}"
previous_temperature=$temperature
EOF
}

function increase_color_temperature() {
  
  local input
  input=$1

  local decrement
  decrement=$(( $previous_temperature*$input/100 ))

  local temperature
  temperature=$(( $previous_temperature-$decrement ))

  validate_temperature $temperature

  redshift -x
  redshift -O $temperature

  echo "increased redshift color from ${previous_temperature}K to ${temperature}K..."

  store_temperature $temperature
}

function decrease_color_temperature() {
  
  local input
  input=$1

  local increase
  increase=$(( $previous_temperature*$input/100 ))

  local temperature
  temperature=$(( $previous_temperature+$increase ))

  validate_temperature $temperature

  redshift -x
  redshift -O $temperature

  echo "decreased redshift color from ${previous_temperature}K to ${temperature}K..."

  store_temperature $temperature
}

function set_color_temperature() {
  
  local temperature
  temperature=$1

  validate_temperature $temperature

  redshift -x
  redshift -O $temperature

  echo "redshift color set to ${temperature}K..."

  store_temperature $temperature
}

function validate_temperature() {

  local temperature
  temperature=$1

  if [[ ! ($temperature -ge 1000 && $temperature -le 25000) ]]; then
    echo "Temperature must be between 1000K and 25000K!"
    exit
  fi
}
