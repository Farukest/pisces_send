i=0
while [ $i -ne 1 ]
do
		i=$(($i+1))
		count=$(pgrep -c lora_pkt_fwd$i)
		echo $count
		if [[ $count -gt 1 ]]; 
		then
		  echo "Killing that pktwds.."
		  pgrep lora_pkt_fwd$i | xargs kill
		fi

		
		if [[ $count -eq 1 ]]; 
		then 
			echo "ALREADY RUNNING";
		else
			echo "STARTING BECAUSE IT HAS STOPPED - "pgrep lora_pkt_fwd$i			
			echo "$i"
			cd /home/ft/hs_ft_pf_$i/ && make -f Makefile
			file=/home/ft/hs_ft_pf_$i/packet_forwarder/lora_pkt_fwd$i
			[ -x $file ] && R="Read = yes" || R="Read = No"
			echo "$R is not executable"
			if ! [ -x $file ]; then
				chmod 700 $file
				echo "$R is now executable..."
			fi
			cd /home/ft/hs_ft_pf_$i/packet_forwarder/ && ./lora_pkt_fwd$i &
			sleep $((20*($i)))
		fi       
		
done

count_local_pf=$(pgrep -c local_pf)
echo $count_local_pf
if [[ $count_local_pf -gt 1 ]]; 
then
  echo "Killing that pktwds.."
  pgrep local_pf | xargs kill
fi


if [[ $count_local_pf -eq 1 ]]; 
then 
	echo "ALREADY RUNNING";
else
	echo "STARTING BECAUSE IT HAS STOPPED - "pgrep local_pf			
	cd /home/ft/hs_ft_pf_3/ && make -f Makefile
	file_local_pf=/home/ft/hs_ft_pf_3/packet_forwarder/local_pf
	[ -x $file_local_pf ] && R="Read = yes" || R="Read = No"
	echo "$R is not executable"
	if ! [ -x $file_local_pf ]; then
		chmod 700 $file_local_pf
		echo "$R is now executable..."
	fi
	cd /home/ft/hs_ft_pf_3/packet_forwarder/ && ./local_pf &
fi       
		

