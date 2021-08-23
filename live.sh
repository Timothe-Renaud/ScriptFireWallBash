#!/bin/bash

# ./brainFW.sh {action} {blockFormat} {target}
# {action} on fais quoi on bloque ou on unblock
# { blockFormat} ip addr, ipRange, PaysComplet
# {target} 192.168.x.x, 192.168.x.x/24, or DE/FR

# amerlioration de la batterie de test ( qui ets le proprietaire du repertoir, a les droits sur les repertoire, est ce que les droits du repertoir son okay etc..)
# Amelioration et optimisation du code par ce que c'est pas fou D:
# le cas oua la vaiable est vide n'est pas traité

WORKPLACE="/root/tmp"
ACTION="$1"
BLOCKFORMAT="$2"
TARGET="$3"

function check_workspace()
{
    WORKPLACE="$1"
    if [[ ! -e "$WORKPLACE" ]]
    then
            echo "$WORKPLACE doesn not exist, creating "
            mkdir $WORKPLACE
    else
            if [[ ! -d "$WORKPLACE" ]]
            then
                    echo "Alert: $WORKPLACE is a file, abording..."
                    exit 1
            else
                    echo "$WORKPLACE is a directory procesing..."
            fi
    fi
}

function get_pays()
{
    WORKPLACE="$1"
    COUNTRY="$2"
    BASE_URL="https://www.ipdeny.com/ipblocks/data/aggregated"
    wget -q $BASE_URL/$COUNTRY-aggregated.zone -O $WORKPLACE/$COUNTRY.zone
}

function blockip()
{
    IP="$1"
    iptable -I INPUT -s "$IP" -j DROP -v
}

function unblockip()
{
    IP="$1"
    iptables -D INPUT -s "$IP" -j DROP -v
}

function core()
{
    ACTION="$1"
    BLOCKFORMAT="$2"
    TARGET="$3"
    WORKPLACE="$4"
    
    if [[ "$BLOCKFORMAT" = "country" ]]
    then
            get_pays "$WORKPLACE" "$TARGET"
            HOWMANYLINES=$(cat "$WORKPLACE/$TARGET.zone" |wc -l)

            if [[ "$ACTION" = "block" ]]
            then
                    SECONDS="0"
                    echo "processing blacklist $HOWMANYLINES for $target country .... plaese wait"
                    for LINE in $(cat "$WORKPLACE/$TARGET.zone")
                    do
                            blockip $LINE > /dev/null
                    done
                    echo "Finito !! pays $TARGET ($HOWMANYLINES) traité in $SECONDS sec"
            elif [[ "$ACTION" = "unblock" ]]
            then
                    SECONDS="0"
                    echo "processing unblacklist $HOWMANYLINES for $target country .... plaese wait"
                    for LINE in $(cat "$WORKPLACE/$TARGET.zone")
                    do
                            unblockip $LINE > /dev/null
                    done
                    echo "Finito !! pays $TARGET ($HOWMANYLINES) traité in $SECONDS sec"
            else
                    echo "$ACTION invalid zerma tes perdus, j'me barre de la...."
                    exit 1
            fi
    elif
            [[ "$BLOCKFORMAT" = "ip" ]]
            then 
                    if [[ "$TARGET" =~ (([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5]))$ ]]
                    then
                            echo "$IP address $TARGET is valid"

                            if [[ $TARGET != 0.0.0.0 ]]
                            then
                                    if [[ "$ACTION" = "block" ]]
                                    then
                                        echo  "processing blacklist just attend frero on est bien la..."
                                        blockip "$TARGET"
                                        echo "Finito la famille! $TARGET blocked"
                                    
                                    elif [[ "$ACTION" = "unblock"]]
                                    then
                                            echo "Processing unblacklist $TARGET ... attend frero"
                                            unblockip "$TARGET"
                                            echo "finito frero $TARGET unblocked"
                                    else
                                            echo "Action invalid, processe aborded...."
                                            exit 1
                                    fi
                            else
                                    echo "You can't do this"
                            fi
                    elif [[ "$TARGET =~ (((25[0-5]|2[0-4][0-9]|1?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|1?[0-9][0-9]?))(\/([1-9]|[1-2][0-9]|3[0-2]))([^0-9.]|$)" ]]
                    then 
                            echo "CIDR range is $TARGET is valid"
                            
                            if [[ $TARGET != 0.0.0.0 ]]
                            then 
                                    if [[ "$ACTION" = "block" ]]
                                    then
                                            echo "processing blacklist $TARGET... plaease wait "
                                            blockip "$TARGET"
                                            echo "done! $TARGET $blocked"
                                   
                                    elif [[ "$ACTION" = "unblock" ]]
                                    then
                                            echo "processing unblacklist $TARGET.. please wait.."
                                            unblockip "$TARGET"
                                            echo "finito poulet, $TARGET unblocker"
                                   
                                    else
                                            echo "$ACTION invalid, process aborded"
                                            exit 1
                                    fi
                            else
                                    echo "you can't do this"
                            fi
                    else
                            echo "error: $TARGET is not valid IP or CIDR"
                            exit 1
                    fi
            else
                    echo "block format: $BLOCKFORMAT is nvalid zerma fais attention"
                    exit 1
            fi      
}

function main()
{
    ACTION="$1"
    BLOCKFORMAT="$2"
    TARGET="$3"
    WORKPLACE="$4"

    check_workspace "$WORKPLACE"
    if [[ "$ACTION" = "help" ]]
    then
            echo "./live.sh {action} {blockFormat} {target}"
            echo "{action} on fais quoi on bloque ou on unblock"
            echo "{ blockFormat} ip addr, ipRange, PaysComplet "
            echo "{target} -> (192.168.x.x) , (192.168.x.x/24) , or code de pays genre DE/FR"
    elif [[ "$ACTION" = "block" ]]
    then 
            code $ACTION $BLOCKFORMAT $TARGET $WORKPLACE
    elif [["$ACTION" = "unblock" ]]
    then
            code $ACTION $BLOCKFORMAT $TARGET $WORKPLACE
    else
            echo "invalide action brolito"
            exit 1
    fi
}

action $ACTION $BLOCKFORMAT $TARGET $WORKPLACE