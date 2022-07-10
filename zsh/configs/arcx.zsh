export GOOGLE_APPLICATION_CREDENTIALS="/Users/aclapinpepin/.gcp/titan.json"
# export GOOGLE_APPLICATION_CREDENTIALS="/Users/aclapinpepin/.gcp/sapphire.json"

export SPARK_CONF_DIR=${HOME}/.spark/

# Activate mamba when cd'ing into a directory with mamba as environment handler
autoload -U add-zsh-hook

trigger_mamba() {
  [[ $PWD =~ data-lakehouse ]] && mamba activate lakehouse
}

add-zsh-hook chpwd trigger_mamba
