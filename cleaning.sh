#!/usr/bin/env bash
rm *.txt &>/dev/null
# all the files ending in txt are our creation

cat data.csv | egrep -i "claim started" > claim_started.txt     #826795
cat data.csv | egrep -i "claim denied" > claim_denied.txt        # 10494
cat data.csv | egrep -i "claim accepted" > claim_accepted.txt    #816301
cat data.csv | egrep -i "quote completed" > quote_completed.txt 
cat data.csv | egrep -i "payment completed" > payment_completed.txt 
echo "basic data slicing completed"

cat payment_completed.txt  | cut -d'-' -f1 | sed -e "s/[\" ]//g" > case_id
cat payment_completed.txt  | cut -d'-' -f2 | sed -e "s/ //g" > plat_form
cat payment_completed.txt  | cut -d'-' -f3 | egrep -o ": [a-z0-9]{6}" | cut -d' ' -f2 > customer
cat payment_completed.txt  | cut -d',' -f2 > timeStamp
paste -d',' case_id plat_form customer timeStamp > payment_completed_basic.txt 
rm case_id plat_form customer timeStamp 
echo "payment_completed_basic.txt created"

# create a table with case_id and json payload 
cat quote_completed.txt | egrep -o "[a-z0-9]{15}" > quote_completed_case
cat quote_completed.txt | egrep -o "\{.*\}" | tr "'" "\"" > quote_completed_payload
paste -d'~' quote_completed_case quote_completed_payload > quote_completed_json.txt
echo "quote_completed_json.txt created"

# clean the quote_completed data
cat quote_completed.txt | egrep -o "'address'\: .*\}"|cut -d':' -f2|tr -d "}" | tr -d "'"> quote_address
cat quote_completed.txt | sed -e s/\{.*\}//g > basic_info 
cat basic_info | cut -d'-' -f1 | sed -e "s/[\" ]//g"> case_id 
cat basic_info | cut -d'-' -f2 | sed -e "s/ //g" > plat_form 
cat basic_info | cut -d'-' -f3 | egrep -o ": [a-z0-9]{6}" | cut -d' ' -f2 > customer
cat basic_info | cut -d',' -f2 > timeStamp
paste -d',' case_id plat_form customer quote_address timeStamp > quote_completed_basic.txt
rm case_id plat_form customer timeStamp quote_completed_case quote_completed_payload quote_address
echo "quote_completed_basic.txt created"

# clean the claim_started data 
cat claim_started.txt | cut -d'-' -f1 | sed -e "s/[\" ]//g"> case_id 
cat claim_started.txt | cut -d'-' -f2 | sed -e "s/ //g" > plat_form 
cat claim_started.txt | cut -d'-' -f3 | egrep -o ": [a-z0-9]{6}" | cut -d' ' -f2 > customer
cat claim_started.txt | cut -d',' -f2 > timeStamp
paste -d',' case_id plat_form customer timeStamp > claim_started_basic.txt
rm case_id plat_form customer timeStamp
echo "claim_started_basic.txt created"

# clean the claim_accepted data 
cat claim_accepted.txt | cut -d'-' -f1 | sed -e "s/[\" ]//g"> case_id 
cat claim_accepted.txt | cut -d'-' -f2 | sed -e "s/ //g" > plat_form 
cat claim_accepted.txt | cut -d'-' -f3 | egrep -o ": [a-z0-9]{6}" | cut -d' ' -f2 > customer
cat claim_accepted.txt | cut -d',' -f2 > timeStamp
cat claim_accepted.txt | egrep -o -i "paid.*,"| egrep -o "[0-9]+\.?[0-9]*" > paid_amount
paste -d',' case_id paid_amount plat_form customer timeStamp > claim_accepted_basic.txt
rm case_id plat_form customer timeStamp paid_amount
echo "claim_accepted_basic.txt created"

