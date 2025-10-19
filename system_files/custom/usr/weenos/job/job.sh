#!/bin/bash

# job jumpscare if someone tries to run nvim, vim, neovim, or vi
IMAGE="/usr/weenos/job/job.png"
SFX="/usr/weenos/job/job.mp3"

(
	feh --fullscreen --zoom fill "$IMAGE" >/dev/null 2>&1 &

	ffplay -nodisp -autoexit "$SFX" >/dev/null 2>&1

	sleep 2

	# kill the job application
	pkill feh >/dev/null 2>&1
) >/dev/null 2>&1 &
disown
