#!/bin/bash

string=`sed -n '4p' helloworld.rb | sed -e 's/^[ \t]*//'`
string1=`echo "${string:1:${#string}-2}"`

string2=`curl http://localhost`

echo "$string1"
echo ""  
echo "$string2"
echo ""  
echo "##########"
echo ""  
if [ "$string1" == "$string2" ]; then echo "Passed"; else echo "Failed"; fi 
exit 0
