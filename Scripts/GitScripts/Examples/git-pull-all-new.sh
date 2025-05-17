#!/bin/bash
#

str=$"/n"
project_array=("ormscamping" "ormscmty" "ormsconfig" "ormslicensing" "ormsmarinas" "ormscore" "ormsreports" "ormsui" "ocam")

for project in ${project_array[@]};
do
	echo $sstr
	echo "start git pull $project code"
	cd $project/
	git pull
	echo "git pull $project code end"
	echo $sstr
	cd ../
done

echo "all sucessful"
