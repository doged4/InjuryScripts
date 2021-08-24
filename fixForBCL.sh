# /bin/bash

# sed "s:[[:space:]],:,:g" *.csv
# dos2unix *.csv

#sed -E "s:[^a-zA-Z0-9,\]],:,:g" $1 > $1.fixed
#dos2unix -n $1.fixed $1
#rm $1.fixed

sed -E "s:[^]a-zA-Z0-9,],:,:g" $1 > $1.fixed
dos2unix -n $1.fixed $1
rm $1.fixed
#=======
#sed "s:[[:space:]],:,:g" $1
#sed "s:[[:space:]],:,:g" $1 | sponge > $1
