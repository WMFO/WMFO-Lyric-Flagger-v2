#!/bin/bash

# WMFO Lyrics Flager
# WMFO - Tufts Freeform Radio
# Version 2.0
# Copyright 2010, 2011 Ben Yu, Andy Sayler, Phil Tang
# Distributed under the terms of the GNU General Public License
#
# process.sh - 
#
# Please maintain attribution/contribution list where praticle
#
# ---Contributors---
# Ben Yu
# ops@wmfo.org
# Andy Sayler
# andy@wmfo.org
# Phil Tang
# ops@wmfo.org
#
# ---File History---
# 10/16/11 - Place under git VCS and added to github repo 
#

mysql_result=`mysql -u <user> <schema> <<< "SELECT NUMBER,ARTIST,TITLE,ALBUM FROM CART WHERE SCHED_CODES IS NULL"`
mysql_result=`echo "$mysql_result" | sed 's/\t/\n/g'`
let c=0
while read number
do
	read artist
	read title
	read album

	#Display the name for debugging
	echo -e "\n$artist\n$title\n$album"

	#Urlencode artist, title, and album. Then send the request.
	artist=`echo -n "$artist" | ./urlencode`
	title=`echo -n "$title" | ./urlencode`
	album=`echo -n "$album" | ./urlencode`
	lookup="http://lyrics.wikia.com/api.php?artist=$artist&song=$title&fmt=xml"

	#Strip out the response and the url.
	xml_response=`wget -o /dev/null -O - "$lookup"`
	xml_response=`echo -n "$xml_response" | tr '\n' ' '`
	lyrics=`echo "$xml_response" | grep -o "<lyrics>.*</lyrics>"`
	lyrics=`echo -n "$lyrics" | sed -e 's/<lyrics>//g' -e 's/<\/lyrics>//g'`
	let lyrics_b=$?
	url=`echo -n "$xml_response" | grep -o "<url>.*</url>" | sed -e 's/<url>//g' -e 's/<\/url>//g' -e 's/amp;//g'`

	if [ $lyrics_b -eq 1 ]
	then
		echo "Closing down due to failure to find lyric tag."
		exit
	fi

	if [ "$lyrics" = "Not found" ]
	then
		echo "No lyrics found for this song."
		query="UPDATE CART SET SCHED_CODES='U          .' WHERE NUMBER='$number'"
	else
		content=`wget -o /dev/null -O - "$url" | grep -o "</a></div>.*<!--" |sed -f html_decode.sed`
		echo -n "$content" | egrep -o -f filter.regex
		if [ $? -eq 0 ]
		then
			echo "This song is explicit!"
			query="UPDATE CART SET SCHED_CODES='E          .' WHERE NUMBER='$number'"
		else
			echo "This song is safe for play."
			query="UPDATE CART SET SCHED_CODES='S          .' WHERE NUMBER='$number'"
		fi
	fi

	if [ $c -ne 0 ]
	then
		mysql -u <user> <schema> <<< "$query"
	else
		let c=1
	fi

done <<< "$mysql_result"

