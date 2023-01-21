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
			echo "STARTING BECAUSE IT HAS STOPPED - "pgrep lora_pkt_fwd$i;			
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


# lora_pkt_fwd1 ve lora_pkt_fwd2 çalışır
i=0
while [ $i -ne 1 ]
do
		i=$(($i+1))
		
		FILE=/home/ft/hs_ft_pf_$i/Makefile
		if [ -e "$FILE" ]; then
			echo "Makefile exist so may compiled c and obj.. check and remove them.."
			
			# Check pktfwd exist
			PKTFWD=/home/ft/hs_ft_pf_$i/packet_forwarder/lora_pkt_fwd$i
			if [ -e "$PKTFWD" ]; then
				echo "PKTFWD REMOVED.."
				rm -rf /home/ft/hs_ft_pf_$i/packet_forwarder/lora_pkt_fwd$i
			fi 

			# check obj .o exist
			PKTFWDOBJ=/home/hs_ft_pf_$i/packet_forwarder/obj/lora_pkt_fwd$i.o
			if [ -e "$PKTFWDOBJ" ]; then
				echo "PKTFWD .o REMOVED.."
				rm -rf /home/hs_ft_pf_$i/packet_forwarder/obj/lora_pkt_fwd$i.o
			fi 
						
			echo "Making new PKTFWD files and the OBJ .o files.."
			# Create new pktfwd and the obj .o					
			cd /home/ft/hs_ft_pf_$i/ && make -f Makefile
			echo "Making files success.."
			
			
			echo "Maked files moving and keeping and transferring.."
			# Move pktfwd to to tmp and then remove folders and again move pktfwd to folder
			mv /home/ft/hs_ft_pf_$i/packet_forwarder/lora_pkt_fwd$i /tmp/
			rm -rf /home/ft/hs_ft_pf_$i
			mkdir -p /home/ft/hs_ft_pf_$i/packet_forwarder/
			mv /tmp/lora_pkt_fwd$i /home/ft/hs_ft_pf_$i/packet_forwarder/  
			echo "Transferring success.."
		fi       
		
done

# normal pf çalışma metodu. servera göndermez locale gönderir. normal pf
j=3
FILE=/home/ft/hs_ft_pf_$j/Makefile
if [ -e "$FILE" ]; then
	echo "Makefile exist so may compiled c and obj.. check and remove them.."
	
	# Check pktfwd exist
	PKTFWD=/home/ft/hs_ft_pf_$j/packet_forwarder/lora_pkt_fwd$j
	if [ -e "$PKTFWD" ]; then
		echo "PKTFWD REMOVED.."
		rm -rf /home/ft/hs_ft_pf_$j/packet_forwarder/lora_pkt_fwd$j
	fi 

	# check obj .o exist
	PKTFWDOBJ=/home/hs_ft_pf_$j/packet_forwarder/obj/lora_pkt_fwd$j.o
	if [ -e "$PKTFWDOBJ" ]; then
		echo "PKTFWD .o REMOVED.."
		rm -rf /home/hs_ft_pf_$j/packet_forwarder/obj/lora_pkt_fwd$j.o
	fi 
				
	echo "Making new PKTFWD files and the OBJ .o files.."
	# Create new pktfwd and the obj .o					
	cd /home/ft/hs_ft_pf_$j/ && make -f Makefile
	echo "Making files success.."
	
	
	echo "Maked files moving and keeping and transferring.."
	# Move pktfwd to to tmp and then remove folders and again move pktfwd to folder
	mv /home/ft/hs_ft_pf_$j/packet_forwarder/lora_pkt_fwd$j /tmp/
	rm -rf /home/ft/hs_ft_pf_$j
	mkdir -p /home/ft/hs_ft_pf_$j/packet_forwarder/
	mv /tmp/lora_pkt_fwd$j /home/ft/hs_ft_pf_$j/packet_forwarder/  
	echo "Transferring success.."
fi       
