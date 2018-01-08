#!/bin/bash
set -e

export MIX_TARGET=rpi0_ap
export MIX_ENV=prod

mix deps.get
mix firmware
mix firmware.push nerves.local --user-dir ~/.ssh/nerves || mix firmware.push nerves.local --user-dir ~/.ssh/nerves
