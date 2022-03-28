
function getdomain () {
    # default file
    if [ ! -n "$1" ]; then 
        include="geolocation-cn"
        echo '|| .cn' >> ./WhiteList.tmp
    else
        include=$1
    fi
    echo $include
    echo "! # ------ ${include} ------" >> ./WhiteList.tmp
    # no full no # domains
    domainlist=`cat ./domainlist/data/${include}|grep -v "#"|grep -v "^$"|grep -v "include:"|grep -v "full:"|cut -d'@' -f 1`
    for domain in ${domainlist}
    do
        echo "||${domain}" >> ./WhiteList.tmp
    done
    # no full # domains
    domainlist=`cat ./domainlist/data/${include}|grep "#"|grep -v "^#"|grep -v "include:"|grep -v "full:"|cut -d'#' -f 1`
    for domain in ${domainlist}
    do
        echo "||${domain}" >> ./WhiteList.tmp
    done
    # full  no # domains
    domainlist=`cat ./domainlist/data/${include}|grep -v "include:"|grep "full:"|grep -v "#"|cut -d':' -f 2`
    for domain in ${domainlist}
    do
        echo "||${domain}" >> ./WhiteList.tmp
    done
    # full  # domains
    domainlist=`cat ./domainlist/data/${include}|grep -v "include:"|grep "full:" |grep "#"|cut -d':' -f 2 |cut -d'#' -f 1`
    for domain in ${domainlist}
    do
        echo "||${domain}" >> ./WhiteList.tmp
    done
    # include file - no#
    includs=`cat ./domainlist/data/${include}|grep "include:"|grep -v "#"|cut -d: -f2`
    for incoude in ${includs}
    do
        getdomain ${incoude}
    done
    # include #
    includs=`cat ./domainlist/data/${include}|grep "include:"|grep "#"|cut -d: -f2|cut -d" " -f1`
    for incoude in ${includs}
    do
        getdomain ${incoude}
    done
}

function getheader(){
    echo "[AutoProxy 0.2.9]
! Expires: 6h
! Title: WhiteList
! White Site List for Everything
! Last Modified: "`date`"
!
! HomePage: https://github.com/0xHO/WhiteList
! License: https://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt
!
! # ------ local network - Regex ------
/10\.\d+\.\d+\.\d+/
/127\.0\.0\.1/
/172\.16\.\d+\.\d+/
/192\.168\.\d+\.\d+/" > ./WhiteList.tmp
}


getheader
getdomain
