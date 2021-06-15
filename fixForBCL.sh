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
#dos2unix $1
#>>>>>>> 3fd4a145bd073c9c11af013676769d0f2809293d
>>>>>>> 49a691dd676e870cb5f1035ef355e364700ec57f
