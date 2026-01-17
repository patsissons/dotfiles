if [ ! -f ~/.provisioned ]; then
  echo Provisioning new machine...

  # TODO: onboard to apps as necessary

  date > ~/.provisioned
  echo Machine provisioned at $(cat ~/.provisioned)
fi
