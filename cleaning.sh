#!/usr/bin/env bash

cat data.csv | egrep -i "claim started" > claim_started     #826795
cat data.csv | egrep -i "claim denied" > claim_denied       # 10494
cat data.csv | egrep -i "claim accepted" > claim_accepted   #816301
cat data.csv | egrep -i "quote completed" > quote_completed
cat data.csv | egrep -i "payment completed" > payment_completed

cat payment_completed | cut -d'-' -f1 | sed -e "s/[\" ]//g" > case_id
cat payment_completed | cut -d'-' -f2 | sed -e "s/ //g" > plat_form
cat payment_completed | cut -d'-' -f3 | egrep -o ": [a-z0-9]{6}" | cut -d' ' -f2 > customer
cat payment_completed | cut -d',' -f2 > timeStamp
paste case_id plat_form customer timeStamp -d',' > payment_completed_basic
rm case_id plat_form customer timeStamp 

# create a table with case_id and json payload 
cat quote_completed | egrep -o "[a-z0-9]{15}" > quote_completed_case
cat quote_completed | egrep -o "\{.*\}" | tr "'" "\"" > quote_completed_payload
paste quote_completed_case quote_completed_payload -d'~' > quote_completed_combined 

# clean the quote_completed data
cat quote_completed | sed -e s/\{.*\}//g > quote_completed_basic 
cat quote_completed_basic | cut -d'-' -f1 | sed -e "s/[\" ]//g"> case_id 
cat quote_completed_basic | cut -d'-' -f2 | sed -e "s/ //g" > plat_form 
cat quote_completed_basic | cut -d'-' -f3 | egrep -o ": [a-z0-9]{6}" | cut -d' ' -f2 > customer
cat quote_completed_basic | cut -d',' -f2 > timeStamp
paste case_id plat_form customer timeStamp -d',' > quote_completed_basic
rm case_id plat_form customer timeStamp quote_completed_case quote_completed_payload

# clean the claim_started data 
cat claim_started | cut -d'-' -f1 | sed -e "s/[\" ]//g"> case_id 
cat claim_started | cut -d'-' -f2 | sed -e "s/ //g" > plat_form 
cat claim_started | cut -d'-' -f3 | egrep -o ": [a-z0-9]{6}" | cut -d' ' -f2 > customer
cat claim_started | cut -d',' -f2 > timeStamp
paste case_id plat_form customer timeStamp -d',' > claim_started_basic 
rm case_id plat_form customer timeStamp

# clean the claim_accepted data 
cat claim_accepted | cut -d'-' -f1 | sed -e "s/[\" ]//g"> case_id 
cat claim_accepted | cut -d'-' -f2 | sed -e "s/ //g" > plat_form 
cat claim_accepted | cut -d'-' -f3 | egrep -o ": [a-z0-9]{6}" | cut -d' ' -f2 > customer
cat claim_accepted | cut -d',' -f2 > timeStamp
cat claim_accepted| egrep -o -i "paid.*,"| egrep -o "[0-9]+\.?[0-9]*" > paid_amount

paste case_id paid_amount plat_form customer timeStamp -d',' > claim_accepted_basic 
rm case_id plat_form customer timeStamp paid_amount