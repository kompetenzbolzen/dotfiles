#!/bin/bash
shopt -s extglob

readonly TMUX_FORMAT='#{session_id};#{session_attached};#{session_name}'

_comp_compgen_known_hosts__impl ()
{
    known_hosts=();
    local configfile="" flag prefix="";
    local cur suffix="" aliases="" i host ipv4="" ipv6="";
    local -a kh tmpkh=() khd=() config=();
    local OPTIND=1;
    while getopts "ac46F:p:" flag "$@"; do
        case $flag in
            a)
                aliases=set
            ;;
            c)
                suffix=':'
            ;;
            F)
                if [[ ! -n $OPTARG ]]; then
                    echo "bash_completion: $FUNCNAME: -F: an empty filename is specified" 1>&2;
                    return 2;
                fi;
                configfile=$OPTARG
            ;;
            p)
                prefix=$OPTARG
            ;;
            4)
                ipv4=set
            ;;
            6)
                ipv6=set
            ;;
            *)
                echo "bash_completion: $FUNCNAME: usage error" 1>&2;
                return 2
            ;;
        esac;
    done;
    if (($# < OPTIND)); then
        echo "bash_completion: $FUNCNAME: missing mandatory argument CWORD" 1>&2;
        return 2;
    fi;
    cur=${!OPTIND};
    ((OPTIND += 1));
    if (($# >= OPTIND)); then
        echo "bash_completion: $FUNCNAME($*): unprocessed arguments:" "$(while (($# >= OPTIND)); do
    printf '%s ' ${!OPTIND}
shift;
done)" 1>&2;
        return 2;
    fi;
    [[ $cur == *@* ]] && prefix=$prefix${cur%@*}@ && cur=${cur#*@};
    kh=();
    if [[ -n $configfile ]]; then
        [[ -r $configfile && ! -d $configfile ]] && config+=("$configfile");
    else
        for i in /etc/ssh/ssh_config ~/.ssh/config ~/.ssh2/config;
        do
            [[ -r $i && ! -d $i ]] && config+=("$i");
        done;
    fi;
    if ((${#config[@]} > 0)); then
        for i in "${config[@]}";
        do
            _comp__included_ssh_config_files "$i";
        done;
    fi;
    if ((${#config[@]} > 0)); then
        if _comp_split -l tmpkh "$(_comp_awk 'sub("^[ \t]*([Gg][Ll][Oo][Bb][Aa][Ll]|[Uu][Ss][Ee][Rr])[Kk][Nn][Oo][Ww][Nn][Hh][Oo][Ss][Tt][Ss][Ff][Ii][Ll][Ee][ \t=]+", "") { print $0 }' "${config[@]}" | sort -u)"; then
            local tmpkh2 j REPLY;
            for i in "${tmpkh[@]}";
            do
                while [[ $i =~ ^([^\"]*)\"([^\"]*)\"(.*)$ ]]; do
                    i=${BASH_REMATCH[1]}${BASH_REMATCH[3]};
                    _comp_expand_tilde "${BASH_REMATCH[2]}";
                    [[ -r $REPLY ]] && kh+=("$REPLY");
                done;
                _comp_split tmpkh2 "$i" || continue;
                for j in "${tmpkh2[@]}";
                do
                    _comp_expand_tilde "$j";
                    [[ -r $REPLY ]] && kh+=("$REPLY");
                done;
            done;
        fi;
    fi;
    if [[ ! -n $configfile ]]; then
        for i in /etc/ssh/ssh_known_hosts /etc/ssh/ssh_known_hosts2 /etc/known_hosts /etc/known_hosts2 ~/.ssh/known_hosts ~/.ssh/known_hosts2;
        do
            [[ -r $i && ! -d $i ]] && kh+=("$i");
        done;
        for i in /etc/ssh2/knownhosts ~/.ssh2/hostkeys;
        do
            [[ -d $i ]] || continue;
            _comp_expand_glob tmpkh '"$i"/*.pub' && khd+=("${tmpkh[@]}");
        done;
    fi;
    if ((${#kh[@]} + ${#khd[@]} > 0)); then
        if ((${#kh[@]} > 0)); then
            for i in "${kh[@]}";
            do
                while read -ra tmpkh; do
                    ((${#tmpkh[@]} == 0)) && continue;
                    [[ ${tmpkh[0]} == [\|\#]* ]] && continue;
                    local host_list=${tmpkh[0]};
                    [[ ${tmpkh[0]} == @* ]] && host_list=${tmpkh[1]-};
                    local -a hosts;
                    if _comp_split -F , hosts "$host_list"; then
                        for host in "${hosts[@]}";
                        do
                            [[ $host == *[*?]* ]] && continue;
                            host=${host#[};
                            host=${host%]?(:+([0-9]))};
                            [[ -n $host ]] && known_hosts+=("$host");
                        done;
                    fi;
                done < "$i";
            done;
        fi;
        if ((${#khd[@]} > 0)); then
            for i in "${khd[@]}";
            do
                if [[ $i == *key_22_*.pub && -r $i ]]; then
                    host=${i/#*key_22_/};
                    host=${host/%.pub/};
                    [[ -n $host ]] && known_hosts+=("$host");
                fi;
            done;
        fi;
        ((${#known_hosts[@]})) && _comp_compgen -v known_hosts -- -W '"${known_hosts[@]}"' -P "$prefix" -S "$suffix";
    fi;
    if [[ ${#config[@]} -gt 0 && -n $aliases ]]; then
        local -a hosts;
        if _comp_split hosts "$(command sed -ne 's/^[[:blank:]]*[Hh][Oo][Ss][Tt][[:blank:]=]\{1,\}\(.*\)$/\1/p' "${config[@]}")"; then
            _comp_compgen -av known_hosts -- -P "$prefix" -S "$suffix" -W '"${hosts[@]%%[*?%]*}"' -X '@(\!*|)';
        fi;
    fi;
    if [[ -n ${BASH_COMPLETION_KNOWN_HOSTS_WITH_AVAHI-} ]] && type avahi-browse &> /dev/null; then
        local generated=$(avahi-browse -cprak 2> /dev/null | _comp_awk -F ';' '/^=/ && $5 ~ /^_(ssh|workstation)\._tcp$/ { print $7 }' | sort -u);
        _comp_compgen -av known_hosts -- -P "$prefix" -S "$suffix" -W '$generated';
    fi;
    if type ruptime &> /dev/null; then
        local generated=$(ruptime 2> /dev/null | _comp_awk '!/^ruptime:/ { print $1 }');
        _comp_compgen -av known_hosts -- -W '$generated';
    fi;
    if [[ -n ${BASH_COMPLETION_KNOWN_HOSTS_WITH_HOSTFILE-set} ]]; then
        _comp_compgen -av known_hosts -- -A hostname -P "$prefix" -S "$suffix";
    fi;
    ((${#known_hosts[@]})) || return 1;
    if [[ -n $ipv4 ]]; then
        known_hosts=("${known_hosts[@]/*:*$suffix/}");
    fi;
    if [[ -n $ipv6 ]]; then
        known_hosts=("${known_hosts[@]/+([0-9]).+([0-9]).+([0-9]).+([0-9])$suffix/}");
    fi;
    if [[ -n $ipv4 || -n $ipv6 ]]; then
        for i in "${!known_hosts[@]}";
        do
            [[ -n ${known_hosts[i]} ]] || unset -v 'known_hosts[i]';
        done;
    fi;
    ((${#known_hosts[@]})) || return 1;
    _comp_compgen -v known_hosts -c "$prefix$cur" ltrim_colon "${known_hosts[@]}"
}

OPTIONS=$(
echo bare
echo new
while IFS=';' read -r ID ATTACHED NAME; do
	printf "%s\t|" "$ID"
	printf " %s" "$NAME"
	test $ATTACHED -ge 1 && printf " (attached)"

	printf "\n"
done <<< "$(tmux ls -F "$TMUX_FORMAT")"
)

CHOICE=$(fzf <<< "$OPTIONS" | awk -F'|' '{ print $1 }')
test -z "$CHOICE" && exit 1

echo $CHOICE

case $CHOICE in
	$+([0-9])* )
		tmux attach -t $CHOICE ;;
	new) tmux ;;
	bare) $SHELL ;;
	*)
		exit 1 ;;
esac
