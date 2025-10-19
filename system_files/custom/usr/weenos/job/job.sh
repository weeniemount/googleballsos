#!/bin/bash

# job jumpscare if someone trys to run nvim, vim, neovim, or vi
IMAGE="/usr/weenos/job/job.png"
SFX="/usr/weenos/job/job.mp3"

feh --fullscreen --zoom fill "$IMAGE" &
ffplay -nodisp -autoexit "$SFX"

sleep 2

# kill the job application
pkill feh