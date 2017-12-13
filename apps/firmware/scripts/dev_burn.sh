#!/bin/bash
set -e

# export MIX_ENV=prod
export MIX_TARGET=rpi0_ap
export MIX_ENV=prod
export NERVES_NETWORK_SSID=TwilightSparkle
export NERVES_NETWORK_PSK=04xterra
export NERVES_NETWORK_KEY_MGMT=WPA-PSK

mix deps.clean --all
mix deps.get
mix firmware
mix firmware.burn
