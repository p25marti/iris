#!/bin/bash

# list all instances
__instances() {
	local full_path
	for DIR in $(ls -1 /opt); do
		full_path=/opt/$DIR/log/
		if [ -d $full_path ]; then
			[[ -n $(find $full_path -name '*.log') ]] && echo $DIR
		fi
	done

}

# get individual log files based on directory
__log_files() {
	[[ ! -d $1 ]] && return
	for FILE in $(ls -1 $1 | egrep '*.log'); do
		echo $FILE
	done
}

# list all instances and their associated logfiles
__ls() {
	local full_path has_log_files
	for DIR in $(ls -1 /opt); do
		if [ -d /opt/$DIR/log ]; then
			
			full_path=/opt/$DIR/log/
			has_log_files=$(find $full_path -name '*.log')
			[[ -n $has_log_files ]] && echo "<== $DIR ==>"

			FILES=$(__log_files $full_path)
			for FILE in $FILES; do
				echo "- $FILE"
			done
			[[ -n $has_log_files ]] && echo # add empty line for spacing
		fi
	done
}

# function used for bash autocompletion
__iris_completion() {
	local cur prev opts prevprev
	local instances="$(__instances)"
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="ls instances logfiles tail"

	case "${prev}" in
		tail | logfiles)
			COMPREPLY=( $(compgen -W "$(__instances)" -- ${cur}) );;
		iris)
			COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) );;
	esac

	# if our last argument was an instance name
	if [[ "$(__instances)" == *"$prev"* ]]; then
		prevprev="${COMP_WORDS[COMP_CWORD-2]}"
		[[ $prevprev == "tail" ]] && COMPREPLY=( $(compgen -W "$(__log_files /opt/$prev/log)" -- ${cur}) )
	fi

}

# actual function that's called
iris() {
	case "$1" in
		"ls")
			__ls;;
		"instances")
			__instances;;
		"logfiles")
			__log_files /opt/$2/log;;
		"tail")
			[[ -f /opt/$2/log/$3 ]] && tail -f /opt/$2/log/$3;;
		*)
			echo "iris [tail <instance> <logfile>]
     [logfiles <instance>]
     [instances]
     [ls]";;
	esac
}

# add bash autocompletion to our new command
complete -F __iris_completion iris
