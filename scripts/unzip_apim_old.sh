#Don't want anymore copied all required parts

#!/bin/bash
source properties.conf

unzip -qq $to_new_path/wso2am-2.1.0.zip -d $to_new_path
i=1
[[ $(ls -A $to_new_path) ]] && for dirs in $to_new_path/*
do
	[[ $dirs =~ .zip ]] && continue
	echo $(basename $dirs)
	re="wso2am-([^/]+)"
	if [[ $(basename $dirs) =~ $re ]]
	then
		eval "version$i=${BASH_REMATCH[1]}"
		i=$((i+1))
		#$version$i=${BASH_REMATCH[1]}
		#i++
		#echo ${BASH_REMATCH[1]}
	fi
done

if [ $version1 \> $version2 ]
then
	echo $version1 is the new version
else
	echo $version1 is the old version
fi

if [ $version2 == "2.1.0" ]
then
	echo "success!!!"
fi

case "$version2" in
	"2.5.0")
		echo "Done!!!"
;;
	*)
		echo "Ruined!!"
;;
esac

#pushd $to_new_path > /dev/null
#ls -I "*.zip"
#popd > /dev/null








