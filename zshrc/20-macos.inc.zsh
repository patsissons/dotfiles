if [ "$(uname)" = "Darwin" ]; then
  echo Configuring macOS...

  CONFIG_DIR="${HOME}/.config"
  PROVISIONED_DIR=~/.provisioned

  DEFAULT_KEYBINDINGS_PATH="${HOME}/Library/KeyBindings/DefaultKeyBinding.dict"
  if [ ! -f "${DEFAULT_KEYBINDINGS_PATH}" ]; then
    [ -d "${HOME}/Library/KeyBindings" ] || mkdir -p "${HOME}/Library/KeyBindings"
    ln -s "${CONFIG_DIR}/macos/DefaultKeyBinding.dict" "${DEFAULT_KEYBINDINGS_PATH}"
  fi

  if [ ! -d "${PROVISIONED_DIR}" ]; then
    echo Provisioning new machine...
    mkdir -p "${PROVISIONED_DIR}"
  fi

  if [ ! -f "${PROVISIONED_DIR}/1password" ]; then
    open -a 1Password && \
    date > "${PROVISIONED_DIR}/1password" && \
    echo 1Password provisioned at $(cat "${PROVISIONED_DIR}/1password")
  fi

  if [ ! -f "${PROVISIONED_DIR}/arc" ]; then
    open -a Arc && \
    date > "${PROVISIONED_DIR}/arc" && \
    echo Arc provisioned at $(cat "${PROVISIONED_DIR}/arc")
  fi

  if [ ! -f "${PROVISIONED_DIR}/itsycal" ]; then
    open -a Itsycal && \
    date > "${PROVISIONED_DIR}/itsycal" && \
    echo Itsycal provisioned at $(cat "${PROVISIONED_DIR}/itsycal")
  fi

  if [ ! -f "${PROVISIONED_DIR}/raycast" ]; then
    open -a Raycast && \
    date > "${PROVISIONED_DIR}/raycast" && \
    echo Raycast provisioned at $(cat "${PROVISIONED_DIR}/raycast")
  fi

  if [ ! -f "${PROVISIONED_DIR}/rectangle" ]; then
    open -a Rectangle && \
    date > "${PROVISIONED_DIR}/rectangle" && \
    echo Rectangle provisioned at $(cat "${PROVISIONED_DIR}/rectangle")
  fi

  if [ ! -f "${PROVISIONED_DIR}/shottr" ]; then
    open -a Shottr && \
    date > "${PROVISIONED_DIR}/shottr" && \
    echo Shottr provisioned at $(cat "${PROVISIONED_DIR}/shottr")
  fi

  # this one is slower so we'll run it at the end
  if [ ! -f "${PROVISIONED_DIR}/kap" ]; then
    softwareupdate --install-rosetta --agree-to-license && \
    open -a Kap && \
    date > "${PROVISIONED_DIR}/kap" && \
    echo Kap provisioned at $(cat "${PROVISIONED_DIR}/kap")
  fi
fi
