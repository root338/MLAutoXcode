#!/bin/sh

filePath=
searchPath="."
file="1*.txt"
placeholder=" "

for path in $(find "${searchPath}" -name "${file}")
do

if [ -z "${filePath}" ];then
filePath="${path}"
else
filePath="${filePath}${placeholder}${path}"
fi

if [ -e "${filePath}" ]; then

echo "${filePath}"
filePath=""

fi
echo "temp filePath = ${filePath}"

done
