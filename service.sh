service=$1
filename=service/${2:-$1}.yaml
noindex=${3:-"xxxxxxxxxxxxxxxxxx"}

# echo $service
# echo $filename
#   - PROCESS-NAME,tv.twitch.android.app
#   - DOMAIN-SUFFIX,ext-twitch.tv
#   - DOMAIN-SUFFIX,jtvnw.net
#   - DOMAIN-SUFFIX,ttvnw.net

function getdomain () {
    # default file
    include=${1// /}
    iscn=$2
    echo $include
    echo "   # ------ ${include} ------>" >> $filename
    grepcn="-v"
    if [[ ${iscn} == 1 ]] ;then
        grepcn=""
    fi
    # DOMAIN
    domains=`cat ./domainlist/data/${include}|grep "full:"|grep ${grepcn} "@cn"|grep -v "^#"|grep -v "@ads"|grep -v "regexp:"|cut -d: -f2|cut -d" " -f1`
    for domain in ${domains}
    do
        domain=${domain// /}
        if [[ -n "$domain" ]]; then
            echo "   - DOMAIN,${domain}" >> $filename
        fi
    done
    # DOMAIN-SUFFIX
    domainsuffixs=`cat ./domainlist/data/${include}|grep -v "full:"|grep -v "include:"|grep ${grepcn} "@cn"|grep -v "regexp:"|grep -v "^$"|grep -v "^#"|grep -v "@ads"|grep -v "regexp:"|cut -d" " -f1`
    for domainsuffix in ${domainsuffixs}
    do
        domainsuffix=${domainsuffix// /}
        if [[ -n "$domainsuffix" ]]; then
            echo "   - DOMAIN-SUFFIX,${domainsuffix}" >> $filename
        fi
    done
    # include
    includs=`cat ./domainlist/data/${include}|grep "include:"|grep -v "^#"|grep -v "${noindex}"|cut -d: -f2|cut -d" " -f1|tr "\n" ""|tr "\r" ""`
    for incoude in ${includs}
    do
        incoude=${incoude// /}
        getdomain ${incoude} ${iscn}
    done
}

echo "# Service: ${service}
# Repo: https://github.com/0xHO/WhiteList/blob/main/${filename}
# Update: `date`
payload:" > $filename

for domain in ${service}
do
    if [[ ${domain: -3} == "@cn" ]]; then
        getdomain ${domain:: -3} 1
    else
        getdomain ${domain} 0
    fi
done
