#!/usr/bin/env bash

# start ssh-agent if not running, otherwise use existing instance
if pgrep ssh-agent > /dev/null; then
  source ~/git/ssh-find-agent/ssh-find-agent.sh
  set_ssh_agent_socket
else
  eval "$(ssh-agent)" > /dev/null
fi

# decode RabbitMQ messages
alias un-rabbit='cat <(printf "\x1f\x8b\x08\x00\x00\x00\x00\x00") <(xclip -o | base64 -d) | gzip -dc | jq'

# apt shortcuts
alias sai='sudo apt install'
alias sar='sudo apt purge'
alias sas='sudo apt search'
alias sau='sudo apt update && sudo apt upgrade'
alias sac='sudo apt autoremove'

fix_wsl2_interop() {
  for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
    if [[ -e "/run/WSL/${i}_interop" ]]; then
      export WSL_INTEROP=/run/WSL/${i}_interop
    fi
  done
}

# (manually) run some tasks on reboot
on-reboot () {
  if ! ipconfig.exe | grep -q sedimentum.internal; then
    echo "Not connected to Sedimentum VPN"
    return 1
  fi

  echo "Adding Sedimentum search domain"
  ipconfig.exe /all | grep -q sedimentum.internal && { grep -q search /etc/resolv.conf || echo search $(ipconfig.exe /all | sed -n 's/\r//;/Search/,/^$/{/^$/q;s/.*://;p}') | sudo tee -a /etc/resolv.conf > /dev/null; }


  LPASS_AGENT_TIMEOUT=0 lpass login fabian.furger@helpany.com --trust

  echo "Modifying ~/.docker/config.json"
  CONFIG=~/.docker/config.json
  if [ -f "$CONFIG" ]; then
    TMP=$(mktemp)
    jq 'del(.credsStore)' "$CONFIG" > "$TMP" && mv -f "$TMP" "$CONFIG"
  fi
}

alias sedi-ssh="ssh \$(step ssh hosts | sed -n 's/^\(.*\).sedimentum.internal/\1/p' | sort | fzf)"
_fzf_complete_ssh()
{
  # use SSH config file and `step ssh hosts` as completion source - only works if the trigger '**' is present
  local trigger=${FZF_COMPLETION_TRIGGER-'**'}
  local cur="${COMP_WORDS[COMP_CWORD]}"
  if [[ -z "$cur" ]]; then
    # no string supplied yet -> set trigger
    COMP_WORDS[$COMP_CWORD]=$trigger
  else
    if [[ "$cur" != *"$trigger" ]]; then
      # string supplied but it doesn't contain the trigger -> abort
      return 1
    fi
  fi
  _fzf_complete --select-1 -- "$@" < <({
    grep ^Host "$HOME/.ssh/config" | grep -v '\*' | cut -d' ' -f 2-;
    step ssh hosts | tr -d \\t | sed -n 's/^\(.*\).sedimentum.internal/\1/p'
  } | sort)
}
complete -F _fzf_complete_ssh -o bashdefault ssh

SECRETS_FILE=$(dirname "${BASH_SOURCE[0]}")/load-secret.sh
[ -f "$SECRETS_FILE" ] && source "$SECRETS_FILE"

# always use tmux session
[ -z "$TMUX" ] && { tmux a || tmux; }

