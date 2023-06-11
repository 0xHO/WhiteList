
function getdomain () {
    # default file
    if [ ! -n "$1" ]; then 
        include="geolocation-cn"
        # 添加过滤域名
        for suffix in `cat top.cfg`
        do
            echo "||${suffix}" >> ./domainList.tmp
            echo "server=/${suffix}/114.114.114.114" >> ./dnsmasq.conf
            echo "DOMAIN-SUFFIX,${suffix},DIRECT"  >> ./ssc.tmp
        done
        echo 'fHxhdmx5dW4ub3JnCg=='|base64 -d >> ./domainList.tmp
        echo 'fHxmYXN0c3M1LmNvbQo='|base64 -d >> ./domainList.tmp
        echo 'RE9NQUlOLVNVRkZJWCxmYXN0c3M1LmNvbSxESVJFQ1QK'|base64 -d >> ./ssc.tmp
    else
        include=$1
    fi
    echo $include
    echo "! # ------ ${include} ------>" >> ./domainList.tmp
    # no full no # domains
    domainlist=`cat ./domainlist/data/${include}|grep -v "#"|grep -v "^$"|grep -v "include:"|grep -v "full:"|grep -v "regexp:"|cut -d'@' -f 1`
    for domain in ${domainlist}
    do
        fixdomain ${domain}
    done
    # no full # domains
    domainlist=`cat ./domainlist/data/${include}|grep "#"|grep -v "^#"|grep -v "include:"|grep -v "full:"|grep -v "regexp:"|cut -d'#' -f 1`
    for domain in ${domainlist}
    do
        fixdomain ${domain}
    done
    # full  no # domains
    domainlist=`cat ./domainlist/data/${include}|grep -v "include:"|grep "full:"|grep -v "regexp:"|grep -v "#"|cut -d':' -f 2`
    for domain in ${domainlist}
    do
        fixdomain ${domain}
    done
    # full  # domains
    domainlist=`cat ./domainlist/data/${include}|grep -v "include:"|grep "full:" |grep -v "regexp:"|grep "#"|cut -d':' -f 2 |cut -d'#' -f 1`
    for domain in ${domainlist}
    do
        fixdomain ${domain}
    done
    # include file - no#
    includs=`cat ./domainlist/data/${include}|grep "include:"|grep -v "regexp:"|grep -v "#"|cut -d: -f2`
    for incoude in ${includs}
    do
        getdomain ${incoude}
    done
    # include #
    includs=`cat ./domainlist/data/${include}|grep "include:"|grep -v "regexp:"|grep "#"|cut -d: -f2|cut -d" " -f1`
    for incoude in ${includs}
    do
        getdomain ${incoude}
    done
}

function fixdomain(){
    # domain=$1
    domain=$(echo "$1" | awk '{$1=$1};gsub(/^ *| *$/, "")')

    if [ "${domain}" == "@cn" ]
    then
        return 1
    fi
    if [ "${domain}" == "@!cn" ]
    then
        return 1
    fi
    if [ "${domain}" == "@ads" ]
    then
        return 1
    fi 
    # 过滤域名
    for suffix in `cat top.cfg`
     do
        if [[ "$domain" == *"$suffix" ]]; then
            return 1
        fi
    done
    #
    echo "||${domain}" >> ./domainList.tmp
    echo "DOMAIN-SUFFIX,${domain},DIRECT"  >> ./ssc.tmp
    echo "server=/${domain}/114.114.114.114" >> ./dnsmasq.conf
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
! # ------ local network (Regex) ------
/10\.\d+\.\d+\.\d+/
/127\.\d+\.\d+\.\d+/
/172\.\d+\.\d+\.\d+/
/192\.168\.\d+\.\d+/" > ./WhiteList.tmp
    echo "[General]
# WhiteList Last Modified: "`date`"
# HomePage: https://github.com/0xHO/WhiteList
# License: https://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt
hijack-dns = 1.1.1.1:53,1.0.0.1:53,8.8.8.8:53,8.8.4.4:53
bypass-system = true
skip-proxy = 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, localhost, *.local, *.apple.com, *.icloud.com 
tun-excluded-routes = 10.0.0.0/8, 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 192.168.0.0/16, 198.51.100.0/24, 203.0.113.0/24, 224.0.0.0/4, 255.255.255.255/32, 239.255.255.250/32
dns-server =  system
ipv6 = false
prefer-ipv6 = false
dns-fallback-system = false
dns-direct-system = false
icmp-auto-reply = true
always-reject-url-rewrite = false
private-ip-answer = true
dns-direct-fallback-proxy = true
bypass-system = true
update-url = https://raw.githubusercontent.com/0xHO/WhiteList/main/ss.conf

[Rule]
" > ./ssc.tmp
echo '' > ./dnsmasq.conf
}


getheader
getdomain
cat ./domainList.tmp >> ./WhiteList.tmp
echo "
# REJECT ads
DOMAIN-KEYWORD,admarvel,REJECT
DOMAIN-KEYWORD,admaster,REJECT
DOMAIN-KEYWORD,adsage,REJECT
DOMAIN-KEYWORD,adsmogo,REJECT
DOMAIN-KEYWORD,adsrvmedia,REJECT
DOMAIN-KEYWORD,adwords,REJECT
DOMAIN-KEYWORD,adservice,REJECT
DOMAIN-SUFFIX,appsflyer.com,REJECT
DOMAIN-KEYWORD,domob,REJECT
DOMAIN-SUFFIX,doubleclick.net,REJECT
DOMAIN-KEYWORD,duomeng,REJECT
DOMAIN-KEYWORD,dwtrack,REJECT
DOMAIN-KEYWORD,avlyun,DIRECT
DOMAIN-KEYWORD,guanggao,REJECT
DOMAIN-KEYWORD,lianmeng,REJECT
DOMAIN-SUFFIX,mmstat.com,REJECT
DOMAIN-KEYWORD,mopub,REJECT
DOMAIN-KEYWORD,omgmta,REJECT
DOMAIN-KEYWORD,openx,REJECT
DOMAIN-KEYWORD,partnerad,REJECT
DOMAIN-KEYWORD,pingfore,REJECT
DOMAIN-KEYWORD,supersonicads,REJECT
DOMAIN-KEYWORD,uedas,REJECT
DOMAIN-KEYWORD,umeng,REJECT
DOMAIN-KEYWORD,usage,REJECT
DOMAIN-SUFFIX,vungle.com,REJECT
DOMAIN-KEYWORD,wlmonitor,REJECT
DOMAIN-KEYWORD,zjtoolbar,REJECT
DOMAIN-KEYWORD,google,PROXY

IP-CIDR,192.168.0.0/16,DIRECT
IP-CIDR,10.0.0.0/8,DIRECT
IP-CIDR,172.16.0.0/12,DIRECT
IP-CIDR,127.0.0.0/8,DIRECT

RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/LocalAreaNetwork.list,DIRECT
RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/UnBan.list,DIRECT
RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaDomain.list,DIRECT
RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaMedia.list,DIRECT
RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanAD.list,REJECT
RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list,REJECT
RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaCompanyIp.list,DIRECT
RULE-SET,https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaIp.list,DIRECT

GEOIP,CN,DIRECT
FINAL,PROXY

[Host]
localhost = 127.0.0.1
" >> ./ssc.tmp
