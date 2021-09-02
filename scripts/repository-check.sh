username=$1
token=$2
yourfilenames=`ls terraform/*.tf`
echo "The repositories below do not exist"
for eachfile in $yourfilenames
do
   repo=$(basename $eachfile .tf)
   json=$(curl -s -u $username:$token https://api.github.com/repos/ministryofjustice/$repo)
   found=$(echo $json | jq .message)
   if [ "$found" == '"Not Found"' ] && [ "$repo" != 'main' ] \
   && [ "$repo" != 'versions' ] && [ "$repo" != 'variables' ];
   then echo "$repo not found"; fi
done
