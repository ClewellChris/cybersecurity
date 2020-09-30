Schedule=$1
Time=$2
Day=$3

cat $1_Dealer_schedule | grep -E $2 | grep -E $3 | awk '{print $1,$2,$5,$6}'
