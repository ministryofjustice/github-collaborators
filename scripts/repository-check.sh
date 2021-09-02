username=$1
token=$2
yourfilenames=`ls terraform/*.tf`
echo "The repositories below do not exist"
for eachfile in $yourfilenames
do
   repo=$(basename $eachfile .tf)
   json=$(curl -s -u $username:$token https://api.github.com/repos/ministryofjustice/$repo)
   echo $json
   bool=$(echo $json | jq 'has("message")')
   found=$(echo $json | jq .message)
   if [ $bool == true ]; then echo "$repo"; fi
done
