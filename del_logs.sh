# List all the alarms
for i in `echo us-east-2 us-east-1 us-west-1 us-west-2 ap-east-1 ap-south-1 ap-northeast-3 ap-northeast-2 ap-southeast-1 ap-southeast-2 ap-northeast-1 ca-central-1 cn-north-1 cn-northwest-1 eu-central-1 eu-west-1 eu-west-2 eu-west-3 eu-north-1 sa-east-1 us-gov-east-1 us-gov-west-1`
do
export AWS_DEFAULT_REGION=$i
echo $i
aws logs describe-log-streams --log-group-name /aws/lambda/StopIdleEC2 --query 'logStreams[*].logStreamName' --output text > log_${i}.csv

for i in `cat log_${i}.csv`
do 
aws logs delete-log-streams --log-group-name /aws/lambda/StopIdleEC2 --log-stream-name $i
done

done
