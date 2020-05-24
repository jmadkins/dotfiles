
clear_docker_logs() {
  if [[ -z $argv ]]; then
      echo "No container specified"
      exit 1
  fi

  if [[ "$(docker ps -aq -f name=^/${argv}$ 2> /dev/null)" == "" ]]; then
      echo "Container \"$argv\" does not exist, exiting."
      exit 1
  fi

  log=$(docker inspect -f '{{.LogPath}}' $argv 2> /dev/null)
  truncate -s 0 $log
}


# PATH modification function
append_if_exists () {
    if [ -e $argv ]; then
	export PATH="$argv:$PATH"
    fi
}

## PATH changes

# Add /usr/local/bin, where Homebrew tends to install things
append_if_exists /usr/local/bin
append_if_exists /usr/local/sbin

# Postgres.app to PATH for psql
append_if_exists /Applications/Postgres.app/Contents/Versions/latest/bin

# Add Heroku to path
append_if_exists /usr/local/heroku/bin
