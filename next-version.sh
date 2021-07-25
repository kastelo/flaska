#!/bin/bash

major=$(git describe --abbrev=0 --match 'v?.*' | tr -d v)
latest=$(git describe --all --abbrev=0 --match 'publish-?.*')
latest="${latest/*-/}"

if [[ $major > $latest ]] ; then
	echo "$major.0"
	exit 0
else
	for ((i = 0; i <= 99; i++)) ; do
		ver="$major.$i"
		if [[ $ver > $latest ]] ; then
			echo "$ver"
			exit 0
		fi
	done
fi

exit 1

