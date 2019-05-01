# List all the Regions
for i in `echo us-east-2 us-east-1 us-west-1 us-west-2 ap-east-1 ap-south-1 ap-northeast-3 ap-northeast-2 ap-southeast-1 ap-southeast-2 ap-northeast-1 ca-central-1 cn-north-1 cn-northwest-1 eu-central-1 eu-west-1 eu-west-2 eu-west-3 eu-north-1 sa-east-1 us-gov-east-1 us-gov-west-1`
do
export AWS_DEFAULT_REGION=$i
echo $i
aws cloudwatch describe-alarms --query 'MetricAlarms[*].AlarmName' --output text > list_${i}.csv

#Delete the alarms
for i in `cat list_${i}.csv`
do 
aws cloudwatch delete-alarms --alarm-names $i 
done

#Delete the logs
aws logs describe-log-groups --query 'logGroups[?starts_with(logGroupName,`/aws/lambda/StopIdleEC2`)].logGroupName' --output table | awk '{print $2}' | grep -v ^$ | while read x; do aws logs delete-log-group --log-group-name $x; done

done
