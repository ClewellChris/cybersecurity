

if [ $1 = Roulette ]
then
	echo "Here is the Roulette Dealer that was working"
	cat $2_Dealer_schedule | grep -E $3 | grep -E $4 | awk '{print $1,$2,$5,$6}'

fi

if [ $1 = Blackjack ]
then
	echo "Here is the Blackjack Dealer that was working"
	cat $2_Dealer_schedule | grep -E $3 | grep -E $4 | awk '{print $1,$2,$3,$4}'

fi

if [ $1 = Texas ]
then
	echo "Here is the Texas Hold 'Em Dealer that was working"
	cat $2_Dealer_schedule | grep -E $3 | grep -E $4 | awk '{print $1,$2,$7,$8}'
fi

date


