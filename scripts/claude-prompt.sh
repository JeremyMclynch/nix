#!/usr/bin/env bash

#claude --model haiku -p "$1" | glow && read -n 1 -s -r -p "Press any key to continue..." _

glow <(claude --model haiku -p "$1") && read -n 1 -s -r -p "Press any key to continue..." _
