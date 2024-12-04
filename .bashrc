# Import pre-bashrc script if exists
[[ -f ~/.bashrc- ]] && . ~/.bashrc-


# Check for interactive mode
if [[ $- == *i* ]]; then
	# Welcome message
	if [ -z "$hide_welcome_message" ]; then
		if ! (( $SHLVL > 1 )); then
			clear
			echo "Welcome, $USER!"
		fi
		LC_TIME="en_US.UTF-8" date "+%A %d. %B %Y - %H:%M"
		echo -en "bash $(if [ ${BASH_VERSINFO[4]} != "release" ];then echo "${BASH_VERSINFO[4]} ";fi )${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}\e[90m.${BASH_VERSINFO[2]}.${BASH_VERSINFO[3]}\e[0m"
		if (( $SHLVL > 1 )) && [ -z "$ignore_shlvl" ]; then echo -e " - nested level $(( "$SHLVL" - 1 ))"; else echo ""; fi
	fi


	# Prompt functions
	_prompt () {
		_e=$?
		if let _COUNTER++; then
			if [ $_e = 0 ]; then
				if [ -z "$display_zero_exitcode" ]; then return 0; fi
				echo -en "\e[90m"
			else
				echo -en "\e[1;91m"
			fi
			echo "Process exited with code $_e"
		fi
	}

	PROMPT_COMMAND=_prompt


	# Set up prompt
	_pWd () {
		if [ "$PWD" = "$HOME" ]; then
			echo "~"
		else
			echo "$PWD"
		fi
	}
	_shlvl () {
		if (( "$SHLVL" > 1 )); then 
			echo -n "\[$_gray\]"
			if [ "$SHLVL" = 2 ]; then
				echo -n ">> "
			else
				echo -n "$(( "$SHLVL" - 1 ))> "
			fi
		fi
	}

	# Colors for prompt
	_red=$(tput setaf 9)
	_yellow=$(tput setaf 11)
	_blue=$(tput setaf 12)
	_gray=$(tput setaf 8)
	_reset=$(tput sgr0)
	
	_suffix="\[$_gray\]>> \[$_reset\]"
	PS1="\[$_reset\]\
$(if [ -z "$ignore_shlvl" ]; then _shlvl; fi)\
\[$_red\]\u\[$_yellow\]@\[$_blue\]\H\[$_reset\] \
\$(_pWd)\
$_suffix"
	PS2="$_suffix"


	# Only modify glob in interactive mode, otherwise the script should specify it
	shopt -s extglob
	shopt -s globstar

	
	# Import post-bashrc script if exists (if running in interactive mode only)
	[[ -f ~/.bashrc+ ]] && . ~/.bashrc+
	true # Reset exit code to 0
fi

