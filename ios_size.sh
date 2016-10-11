#!/bin/bash
apkpath=$1

rm -rf ios_size_$apkpath.log

echo "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️---- total size ----❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️" >> ios_size_$apkpath.log
du -sh $apkpath >>ios_size_$apkpath.log
echo "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️---- pic----❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️" >> ios_size_$apkpath.log
du -a -h  $apkpath/* | grep -E 'svg|png|jpg|gif' |grep [1-9]M |sort -r -n -t " "| sed -n '1,30p' >> ios_size_$apkpath.log
du  -h -a $apkpath/* | grep -E 'svg|png|jpg|gif' |sort -r -n -t " "|sed -n '1,30p' >> ios_size_$apkpath.log

echo "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️---- other files ----❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️" >> ios_size_$apkpath.log
du  -h -a  $apkpath/* | grep "M" | grep -v "K"|grep -v -E 'svg|png|jpg|gif|/AwemeInhouse$|/assets$|/res$|/src$|/bundle$|/images$|/_CodeSignature$|/node_modules$|/react-native$|/Libraries$|/CustomComponents$|/NavigationExperimental$|/JokeInhouse$|/CodeResources$|/script$|/LiveStreamingInhouse$' |sort -r -n -t " "  >>ios_size_$apkpath.log
du  -h -a  $apkpath/* |  grep "K" |grep -v  -E  'svg|png|M|jpg|gif'|sort -r -n -t " "|sed -n '1,50p' >>ios_size_$apkpath.log

echo "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️---- core files ----❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️" >> ios_size_$apkpath.log

maptxt=`ls | grep "txt"`
node linkmap.js $maptxt -hl > log.log
column -t < log.log > logg.log
head20=`head -n 20 logg.log > loggg.log`
more loggg.log >>ios_size_$apkpath.log
rm -rf logg.logg
rm -rf loggg.log

date_log=`date +%m_%d_%X`
echo $date_log
mkdir -p report/"$apkpath"_
cp ios_size_$apkpath.log  ./report/"$apkpath"_/ios_"$date_log".log

flater_pic_m=`more ios_size_$apkpath.log | grep -E 'jpg|png'|grep [0-9]M | awk -F 'M' 'NR==1 {print $1}' `
flater_pic_k=`more ios_size_$apkpath.log | grep -E 'jpg|png'|grep -v M | awk -F 'K' 'NR==1 {print $1}' `

echo $flater_pic_m
echo $flater_pic_k

y=`echo "$flater_pic_m > 1"|bc`  
echo $y

z=`echo "$flater_pic_k > 1000"|bc`  
echo $z

if [[ "$y" -eq 1 || "$z" -eq 1 ]]; then
	echo ！！！！！！！图片过大报警！！！！！！ > msg.log
	echo http://ci.byted.org/view/aweme/job/UGC_package_size/ws/ios_size_$apkpath.log >>msg.log
	python dingding_msg.py

fi

nowfile=`ls report/${apkpath}_/  |sort |  tail -2 | sed -n 2p`
echo $nowfile
lastfile=`ls report/${apkpath}_/  |sort |  tail -2 | sed -n 1p `
echo $lastfile
nowfile_size=`more report/${apkpath}_/${nowfile} | awk -F 'M' 'NR == 2 {print $1}'`
echo $nowfile_size
lastfile_size=`more report/${apkpath}_/${lastfile} | awk -F 'M' 'NR == 2 {print $1}'`
echo $lastfile_size
x=`echo "$nowfile_size - $lastfile_size -5"|bc`  
echo $x
w=`echo "$x > 0"|bc`  
echo $w


if [[ "$w" -eq 1 ]]; then
	echo ！！！！！！！新版本包大了5M以上啦！！！！！！ > msg.log
	echo http://ci.byted.org/view/aweme/job/UGC_package_size/ws/ios_size_$apkpath.log >>msg.log
	python dingding_msg.py
fi


