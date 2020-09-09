# /bin/bash

# sed "s:[[:space:]],:,:g" *.csv
# dos2unix *.csv

#sed "s:[[:space:]],:,:g" $1
sed "s:[[:space:]],:,:g" $1 | sponge > $1
dos2unix $1
