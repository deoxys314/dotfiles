set -g os DEBUG

function get_operating_system
    set --function kernel_name (uname -s)
    # cribbed from neofetch source
    switch $kernel_name
        case Darwin
            set os OSX
        case SunOS
            set os Solaris
        case Haiku
            set os Haiku
        case MINIX
            set os MINIX
        case AIX
            set os AIX
        case 'IRIX*'
            set os IRIX
        case FreeMiNT
            set os FreeMiNT
        case Linux 'GNU*'
            set os Linux
        case '*BSD' DragonFly Bitrig
            set os BSD
        case 'CYGWIN*' 'MSYS*' 'MINGW*'
            set os Windows
        case '*'
            printf '%s\n' "Unknown os detected: $kernel_name, bailing out"
            return 1
    end
end


function info
    if test -n "$argv[2]"
        printf '%s%s%s: %s' (set_color --bold yellow) "$argv[1]" (set_color normal) "$argv[2]"
    end
end

function battery
    switch $os
        case OSX
            set -l percent (pmset -g batt | grep -o '[0-9]*%')
            set -l state (pmset -g batt | awk '/;/ {print $4}')
            test "$state" = 'charging;'; and set state ', charging'; or set state ''
            printf '%s%s' $percent $state
        case '*'
            echo Unknown
    end
end

function has_battery
    return 0
end

function colors
    set --local color_list (set_color --print-colors | grep -v br)
    if test -n "$argv[1]"
        set color_list (set_color --print-colors | grep br)
    end
    for color in $color_list
        printf '%s   %s' (set_color --background $color black) (set_color normal)
    end
end

function get_shell
    if test -z "$SHELL"
        printf Unknown
        return
    end
    set --local shell_version ($SHELL --version | grep -Eo '\d+\.\d+\.\d+')
    set --local shell_name (basename $SHELL)
    printf '%s %s' $shell_name $shell_version
end

function get_tmux_info
    if test -z "$TMUX"
        echo "Not in tmux"
        return
    end
    set --local tmux_sessions (tmux list-sessions -F '#{session_name}')
    set --local session_count (count $tmux_sessions)
    printf '%d session%s (%s)' $session_count (if test 1 -eq $session_count; echo ''; else; echo 's'; end) "$tmux_sessions"
end

function get_uptime
    switch $os
        case OSX
            set --function up_seconds (math (date +%s) - (sysctl -n kern.boottime | awk '{print $4}' | tr -d ','))
        case Linux
            set --function up_seconds 0
        case '*'
            set --function up_seconds 2000000000000
    end
    set --local days (math -s0 $up_seconds / 60 / 60 / 24)
    if test $days -eq 0
        set days ''
    else if test $days -eq 1
        set days $days day,
    else
        set days $days days,
    end
    set --local hours (math -s0 $up_seconds / 60 / 60 % 24)
    if test $hours -eq 0
        set hours ''
    else if test $hours -eq 1
        set hours $hours hour,
    else
        set hours $hours hours,
    end
    set --local minutes (math -s0 $up_seconds / 60 % 60)
    if test $minutes -eq 0
        set minutes ''
    else if test $minutes -eq 1
        set minutes $minutes minute
    else
        set minutes $minutes minutes
    end
    echo "$days" "$hours" "$minutes"
end

function neofish
    set --function -x fish_trace true

    get_operating_system

    set -l ascii_art (string split '\n' (fish_logo))
    set -l status_data (string split '\n' -- (printf '%s\n' \
		(set_color green --underline --bold)'NeoFish'(set_color normal) \
		'=======' \
		(info OS $os) \
		(info Host (hostname)) \
		(info Uptime (get_uptime)) \
		(info Shell (get_shell)) \
		(info Terminal $TERM) \
		(info tmux (get_tmux_info)) \
		(info Battery (battery)) \
		'' \
		(colors) (colors 1) \
		) \
		)

    set --local num_of_lines (math max (count $ascii_art ), (count $status_data) )

    set --local left_width 0
    for i in (seq 1 (count $ascii_art))
        set left_width (math 'max(' $left_width ',' (string length --visible $ascii_art[$i]) ')' )
    end

    for i in (seq 1 $num_of_lines)
        printf '%s %s   %s\n' (string pad --right --width $left_width $ascii_art[$i]) (set_color normal) $status_data[$i]
    end
end
