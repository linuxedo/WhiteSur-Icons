#!/bin/bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

THEME_NAME=WhiteSur
COLOR_VARIANTS=('' '-Dark')
THEME_VARIANTS=('' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Grey' '-Aqua' '-Sand' '-Black')

usage() {
cat << EOF
  Usage: $0 [OPTION]...

  OPTIONS:
    -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
    -n, --name NAME         Specify theme name (Default: $THEME_NAME)
    -t, --theme VARIANT     Specify theme color variant(s) [default|Purple|Pink|Red|Orange|Yellow|Green|Grey|Aqua|Sand|Black|all] (Default: blue)
    -a, --alternative       Install alternative icons for software center and file-manager
    -b, --bold              Install bold panel icons version
    --black                 Black panel icons version
    -h, --help              Show help
EOF
}

install() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local color=${4}

  local THEME_DIR=${dest}/${name}${color}${theme}

  [[ -d ${THEME_DIR} ]] && rm -rf ${THEME_DIR}

  echo "Installing '${THEME_DIR}'..."

  mkdir -p                                                                             ${THEME_DIR}
  cp -r ${SRC_DIR}/{COPYING,AUTHORS}                                                   ${THEME_DIR}
  cp -r ${SRC_DIR}/src/index.theme                                                     ${THEME_DIR}

  cd ${THEME_DIR}
  sed -i "s/${name}/${name}${color}${theme}/g" index.theme

  if [[ ${color} == '' ]]; then
    mkdir -p                                                                               ${THEME_DIR}/status
    cp -r ${SRC_DIR}/src/{actions,animations,apps,categories,devices,emblems,mimes,places} ${THEME_DIR}
    cp -r ${SRC_DIR}/src/status/{16,22,24,32,symbolic}                                     ${THEME_DIR}/status

    if [[ ${black:-} == 'true' ]]; then
      sed -i "s/#ffffff/#363636/g" "${THEME_DIR}"/status/{16,22,24}/*
    fi

    if [[ ${bold:-} == 'true' ]]; then
      cp -r ${SRC_DIR}/bold/*                                                              ${THEME_DIR}
    fi

    cp -r ${SRC_DIR}/links/{actions,apps,categories,devices,emblems,mimes,places,status}   ${THEME_DIR}

    if [[ $DESKTOP_SESSION == '/usr/share/xsessions/budgie-desktop' ]]; then
      cp -r ${SRC_DIR}/src/status/symbolic-budgie/*.svg                                    ${THEME_DIR}/status/symbolic
    fi

    if [[ ${alternative:-} == 'true' ]]; then
      cp -r ${SRC_DIR}/alternative/apps/*.svg                                              ${THEME_DIR}/apps/scalable
    fi

    if [[ ${theme} != '' ]]; then
      cp -r ${SRC_DIR}/colors/Color${theme}/*.svg                                          ${THEME_DIR}/places/scalable
    fi
  fi

  if [[ ${color} == '-Dark' ]]; then
    mkdir -p                                                                           ${THEME_DIR}/{apps,categories,emblems,devices,mimes,places,status}

    cp -r ${SRC_DIR}/src/actions                                                       ${THEME_DIR}
    cp -r ${SRC_DIR}/src/apps/symbolic                                                 ${THEME_DIR}/apps
    cp -r ${SRC_DIR}/src/categories/symbolic                                           ${THEME_DIR}/categories
    cp -r ${SRC_DIR}/src/emblems/symbolic                                              ${THEME_DIR}/emblems
    cp -r ${SRC_DIR}/src/mimes/symbolic                                                ${THEME_DIR}/mimes
    cp -r ${SRC_DIR}/src/devices/{16,22,24,symbolic}                                   ${THEME_DIR}/devices
    cp -r ${SRC_DIR}/src/places/{16,22,24,symbolic}                                    ${THEME_DIR}/places
    cp -r ${SRC_DIR}/src/status/{16,22,24,symbolic}                                    ${THEME_DIR}/status

    if [[ ${bold:-} == 'true' ]]; then
      cp -r ${SRC_DIR}/bold/*                                                          ${THEME_DIR}
    fi

    if [[ $DESKTOP_SESSION == '/usr/share/xsessions/budgie-desktop' ]]; then
      cp -r ${SRC_DIR}/src/status/symbolic-budgie/*.svg                                ${THEME_DIR}/status/symbolic
    fi

    # Change icon color for Dark theme
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,devices,places,status}/{16,22,24}/*
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/actions/32/*
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,apps,categories,emblems,devices,mimes,places,status}/symbolic/*

    cp -r ${SRC_DIR}/links/actions/{16,22,24,32,symbolic}                              ${THEME_DIR}/actions
    cp -r ${SRC_DIR}/links/devices/{16,22,24,symbolic}                                 ${THEME_DIR}/devices
    cp -r ${SRC_DIR}/links/places/{16,22,24,symbolic}                                  ${THEME_DIR}/places
    cp -r ${SRC_DIR}/links/status/{16,22,24,symbolic}                                  ${THEME_DIR}/status
    cp -r ${SRC_DIR}/links/apps/symbolic                                               ${THEME_DIR}/apps
    cp -r ${SRC_DIR}/links/categories/symbolic                                         ${THEME_DIR}/categories
    cp -r ${SRC_DIR}/links/mimes/symbolic                                              ${THEME_DIR}/mimes

    cd ${dest}
    ln -s ../${name}${theme}/animations ${name}-Dark${theme}/animations
    ln -s ../../${name}${theme}/categories/32 ${name}-Dark${theme}/categories/32
    ln -s ../../${name}${theme}/emblems/16 ${name}-Dark${theme}/emblems/16
    ln -s ../../${name}${theme}/emblems/22 ${name}-Dark${theme}/emblems/22
    ln -s ../../${name}${theme}/emblems/24 ${name}-Dark${theme}/emblems/24
    ln -s ../../${name}${theme}/mimes/16 ${name}-Dark${theme}/mimes/16
    ln -s ../../${name}${theme}/mimes/22 ${name}-Dark${theme}/mimes/22
    ln -s ../../${name}${theme}/mimes/scalable ${name}-Dark${theme}/mimes/scalable
    ln -s ../../${name}${theme}/apps/scalable ${name}-Dark${theme}/apps/scalable
    ln -s ../../${name}${theme}/devices/scalable ${name}-Dark${theme}/devices/scalable
    ln -s ../../${name}${theme}/places/scalable ${name}-Dark${theme}/places/scalable
    ln -s ../../${name}${theme}/status/32 ${name}-Dark${theme}/status/32
  fi

  (
    cd ${THEME_DIR}
    ln -sf actions actions@2x
    ln -sf animations animations@2x
    ln -sf apps apps@2x
    ln -sf categories categories@2x
    ln -sf devices devices@2x
    ln -sf emblems emblems@2x
    ln -sf mimes mimes@2x
    ln -sf places places@2x
    ln -sf status status@2x
  )

  gtk-update-icon-cache ${THEME_DIR}
}

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    -d|--dest)
      dest="$2"
      mkdir -p "$dest"
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -a|--alternative)
      alternative='true'
      echo "Installing 'alternative' version..."
      shift
      ;;
    -b|--bold)
      bold='true'
      echo "Installing 'bold' version..."
      shift
      ;;
    --black)
      black='true'
      echo "Installing 'black on panel' version..."
      shift
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          default)
            themes+=("${THEME_VARIANTS[0]}")
            shift
            ;;
          Purple)
            themes+=("${THEME_VARIANTS[1]}")
            shift
            ;;
          Pink)
            themes+=("${THEME_VARIANTS[2]}")
            shift
            ;;
          Red)
            themes+=("${THEME_VARIANTS[3]}")
            shift
            ;;
          Orange)
            themes+=("${THEME_VARIANTS[4]}")
            shift
            ;;
          Yellow)
            themes+=("${THEME_VARIANTS[5]}")
            shift
            ;;
          Green)
            themes+=("${THEME_VARIANTS[6]}")
            shift
            ;;
          Grey)
            themes+=("${THEME_VARIANTS[7]}")
            shift
            ;;
          Aqua)
            themes+=("${THEME_VARIANTS[8]}")
            shift
            ;;
          Sand)
            themes+=("${THEME_VARIANTS[9]}")
            shift
            ;;
          Black)
            themes+=("${THEME_VARIANTS[10]}")
            shift
            ;;
          all)
            themes+=("${THEME_VARIANTS[@]}")
            shift
            ;;
          -*|--*)
            break
            ;;
          *)
            prompt -e "ERROR: Unrecognized theme variant '$1'."
            prompt -i "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
        # echo "Installing '${theme}' folder version..."
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#themes[@]}" -eq 0 ]] ; then
  themes=("${THEME_VARIANTS[0]}")
fi

if [[ "${#colors[@]}" -eq 0 ]] ; then
  colors=("${COLOR_VARIANTS[@]}")
fi

install_theme() {
  for theme in "${themes[@]}"; do
    for color in "${colors[@]}"; do
      install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done
}

install_theme
