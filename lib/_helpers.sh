#!/bin/bash
#
# Executes streamlink

function store_values() {
  
  local temperature
  local brightness
  temperature=$1
  brightness=$2

  touch $CONFIG_PATH

  cat << EOF > "${CONFIG_PATH}"
previous_temperature=$temperature
previous_brightness=$brightness
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

  redshift -P -O $temperature -b $previous_brightness

  echo "increased redshift color from ${previous_temperature}K to ${temperature}K..."

  store_values $temperature $previous_brightness
}

function decrease_color_temperature() {
  
  local input
  input=$1

  local increase
  increase=$(( $previous_temperature*$input/100 ))

  local temperature
  temperature=$(( $previous_temperature+$increase ))

  validate_temperature $temperature

  redshift -P -O $temperature -b $previous_brightness

  echo "decreased redshift color from ${previous_temperature}K to ${temperature}K..."

  store_values $temperature $previous_brightness
}

function set_color_temperature() {
  
  local temperature
  temperature=$1

  validate_temperature $temperature

  redshift -P -O $temperature -b $previous_brightness

  echo "redshift color set to ${temperature}K..."

  store_values $temperature $previous_brightness
}

function validate_temperature() {

  local temperature
  temperature=$1

  if [[ ! ($temperature -ge 1000 && $temperature -le 25000) ]]; then
    echo "Temperature must be between 1000K and 25000K!"
    exit
  fi
}

function increase_brightness() {
  
  local input
  input=$1

  local brightness
  
  # no floating point number in bash, workaround
  brightness=$(echo "$previous_brightness+$input" | bc -l)
  
  validate_brightness $brightness

  
  # Somehow you need to pass in a temperature to adjust the brightness, prevent "Waiting for initial location to become available..." message
  redshift -P -O $previous_temperature -b $brightness

  echo "increased redshift brightness from ${previous_brightness} to ${brightness}"

  store_values $previous_temperature $brightness
}

function decrease_brightness() {
  
  local input
  input=$1

  local brightness
  
  # no floating point number in bash, workaround
  brightness=$(echo "$previous_brightness-$input" | bc -l)
  
  validate_brightness $brightness

  redshift -P -O $previous_temperature -b $brightness

  echo "decreased redshift brightness from ${previous_brightness} to ${brightness}"

  store_values $previous_temperature $brightness
}

function validate_brightness() {

  local brightness
  brightness=$1

  echo $brightness
  
  # convert to int: https://unix.stackexchange.com/questions/89712/how-to-convert-floating-point-number-to-integer
  brightness=$(echo "($1*10)/1" | bc)
  
  echo $brightness
  
  if [[ ! ($brightness -ge 1 && $brightness -le 10) ]]; then
    echo "Brightness must be between 0.1 and 1.0"
    exit
  fi
}
