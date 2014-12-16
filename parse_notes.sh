#!/bin/bash

if [ "$1" = "help" ]
then 
	echo "usage: ${0} <file_to_parse>";
	echo "In file_to_parse:"
	echo "	Use \"%!STRING\" inside of /begin{frame} and /end{frame} environment, STRING will then be written into a valid xml-file, that can be read by open-pdf-presenter"
	exit;
fi
echo "Parsing notes to notes.xml"
touch notes.xml;
echo "<notes>" > notes.xml;
i=1;
while read line;
do 
	s1=${line:0:2};

	if [ "${line:0:12}" = "begin{frame}" ]
	then
		echo "<note number=\"${i}\">" >> notes.xml;
	elif [ "${line}" = "framebreak" ] || [ "${line:0:7}" = "uncover" ]
	then 
		echo "</note>" >> notes.xml;
		i=$((i + 1));
		echo "<note number=\"${i}\">" >> notes.xml;
	elif [ "${line}" = "end{frame}" ]
	then
		echo "</note>" >> notes.xml;
		i=$((i + 1));
	elif [ "${s1}" = "%!" ]
	then
		echo ${line:2} >> notes.xml;
	fi
done  < $1
echo "</notes>" >> notes.xml;
