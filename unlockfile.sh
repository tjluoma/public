#!/usr/bin/env zsh -f
# Purpose: use Unix tools to allow a file to be modified
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2020-01-14

NAME="$0:t:r"

if [[ -e "$HOME/.path" ]]
then
	source "$HOME/.path"
fi

COUNT='0'

for i in "$@"
do

	[[ ! -e "$i" ]] && echo "$NAME: '$i' does not exist." && continue

		# un-set the system immutable flag (super-user only)
	sudo chflags noschg "$i"

	EXIT="$?"

	if [ "$EXIT" = "0" ]
	then
		echo " ✔️	$NAME: success 'chflags noschg' on '$i'"

	else
		echo "$NAME: FAILED 'chflags noschg' on '$i'" >>/dev/stderr

		((COUNT++))
	fi

		# un-set the user immutable flag (owner or super-user only)
	sudo chflags nouchg "$i"

	EXIT="$?"

	if [ "$EXIT" = "0" ]
	then
		echo " ✔️	$NAME: success 'chflags nouchg' on '$i'"

	else
		echo "$NAME: FAILED 'chflags nouchg' on '$i'" >>/dev/stderr

		((COUNT++))
	fi

		# add basic 'write' permissiong
	sudo chmod u+w "$i"

	EXIT="$?"

	if [ "$EXIT" = "0" ]
	then
		echo " ✔️	$NAME: success in giving 'user write' permissions to '$i'"

	else
		echo "$NAME: FAILED to add 'user write' permissions from '$i'" >>/dev/stderr

		((COUNT++))
	fi

done

if [[ "$COUNT" == "0" ]]
then

	echo "$NAME: Finished with no errors."
	exit 0

elif [[ "$COUNT" == "1" ]]
then

	echo "$NAME: Finished with 1 error."
	exit 1

else

	echo "$NAME: Finished with $COUNT errors."
	exit "$COUNT"

fi

#EOF
