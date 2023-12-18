#!/bin/bash
#brightnessctl -d 'tpacpi::lid_logo_dot' s 100


# For some reason, the TP dot only blinks consistently for > 0.7s

DEVICE='tpacpi::lid_logo_dot'
#DEVICE='input4::capslock'

LED_PATH="/sys/class/leds/$DEVICE"

function led() {
	#echo $1 > "$LED_PATH/brightness"
	brightnessctl -d "$DEVICE" s $1 > /dev/null
}

LONG='1.4'
SHORT='0.7'
INT_PAUSE='0.7'
EXT_PAUSE='1'

function morse() {
	for w in $@; do
		echo $w
		echo $w | fold -w1 | while read c; do
			led 1
			case $c in
				.)
					sleep $SHORT;;
				-)
					sleep $LONG;;
				*);;
			esac
			led 0
			sleep $INT_PAUSE
		done

		sleep $EXT_PAUSE
	done
}

function to_morse() {
	for w in $@; do
		echo ${w,,} | fold -w1 | while read c; do
			case $c in
				a) echo .- ;;
				b) echo -... ;;
				c) echo -.-. ;;
				d) echo -.. ;;
				e) echo . ;;
				f) echo ..-. ;;
				g) echo --. ;;
				h) echo .... ;;
				i) echo .. ;;
				j) echo .--- ;;
				k) echo -.- ;;
				l) echo .-.. ;;
				m) echo -- ;;
				n) echo -. ;;
				o) echo --- ;;
				p) echo .--. ;;
				q) echo --.- ;;
				r) echo .-. ;;
				s) echo ... ;;
				t) echo - ;;
				u) echo ..- ;;
				v) echo ...- ;;
				w) echo .-- ;;
				x) echo -..- ;;
				y) echo -.-- ;;
				z) echo --.. ;;
			esac
		done
	done
}

TEXT="$@"

AAA=( $(to_morse $TEXT) )
morse ${AAA[@]}
