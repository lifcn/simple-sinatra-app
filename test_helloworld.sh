#!/bin/bash

# uncomment out below lines to clear legacy container
# if not yet done in build stage
#docker stop simple-sinatra-app
#docker rm simple-sinatra-app

# launch new container in service mode from image local/simple-sinatra-app
# expose port 80/tcp 
docker run -d -p 80:4567 --name simple-sinatra-app local/simple-sinatra-app

# sleep 300 seconds
sleep 300 

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
