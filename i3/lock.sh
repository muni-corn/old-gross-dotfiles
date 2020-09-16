#!/usr/bin/env bash

if pgrep -x i3lock >/dev/null
then
    echo "i3lock is already running"
    exit
fi

FORK=''

# parse args
while (( "$#" )); do
    case "$1" in
        -w|--warn)
            notify-send -u low -t 29500 -- 'Are you still there?' 'Your system will lock itself soon.'
            paplay $HOME/Music/MuseSounds/stereo/LockWarning.oga
            exit
            ;;
        -n|--no-fork)
            echo "i3lock won't fork"
            FORK='-n'
            shift
            ;;
    esac
done

paplay /usr/share/sounds/musicaflight/stereo/Lock.oga &

# suspend notifications
# pkill -u "$USER" -USR1 dunst

tmpbg="$HOME/.lock_screen.png"

primary="fcffffff"
secondary="b1c334c0"
transparent="00000000"

/usr/bin/i3lock $FORK -t -i "$tmpbg" \
    -e \
    -c 000000ff \
    --clock \
    --ringcolor=$transparent \
    --ringwrongcolor=ff0000aa \
    --ringvercolor=$secondary \
\
    --radius 64 \
    --ring-width 2 \
\
    --insidecolor=$transparent \
    --insidevercolor=$transparent \
    --insidewrongcolor=$transparent \
\
    --keyhlcolor=$primary \
    --bshlcolor=$secondary \
    --separatorcolor=$transparent \
    --linecolor=$transparent \
\
    --timecolor=$primary \
    --datecolor=$secondary \
    --verifcolor=$secondary \
    --wrongcolor=ff0000ff \
\
    --timestr="%-I:%M %P" \
    --datestr="%A, %B %-d" \
\
    --time-align=1 \
    --date-align=1 \
    --verif-align=1 \
    --wrong-align=1 \
\
    --indpos="256+r:h-256+r" \
    --timepos="256:256" \
    --datepos="tx:ty+64" \
\
    --time-font="Inter Thin" \
    --date-font="sans" \
    --verif-font="sans" \
    --wrong-font="sans" \
\
    --timesize=128 \
    --datesize=24 \
    --verifsize=16 \
    --wrongsize=16 \
\
    --veriftext="" \
    --wrongtext="" \
    --noinputtext="" \
\
    --pass-media-keys \
    --pass-screen-keys \

# resume notifications
# pkill -u "$USER" -USR2 dunst

