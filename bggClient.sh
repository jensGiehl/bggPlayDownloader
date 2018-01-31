#!/bin/bash

if [[ -z "${BGG_USER}" ]]; then
   echo -e "Please set \033[0;31mBGG_USER\033[0m as enviorment variable"
   exit 1
fi

numberOfRows=9999
page=1
outputFile="$BGG_USER.xml"
currentDate=`date '+%Y-%m-%d_%H%M'`
targetDir="$BGG_USER/$currentDate"
mkdir --parents $targetDir
while [ $numberOfRows -gt 1 ]
do
   ./wgetRetry.sh "https://www.boardgamegeek.com/xmlapi2/plays?username=$BGG_USER&page=$page" $outputFile
   #wget -q --no-http-keep-alive --output-document=$outputFile "https://www.boardgamegeek.com/xmlapi2/plays?username=$BGG_USER&page=$page"
   numberOfRows=`cat $outputFile |wc -l`
   logger "BGG Page $page has $numberOfRows rows (User=$BGG_USER)"
   if [ $numberOfRows -gt 1 ]; then
	mv $outputFile "$targetDir/page_$page.xml"
   fi
   page=$((page+1))
done

rm $outputFile
