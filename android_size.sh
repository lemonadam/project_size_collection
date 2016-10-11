#!/bin/bash
apkpath=$1
rm -rf android_size_$apkpath.log
#rm -rf apk


#unzip $apkpath -d apk
sleep 4s
echo "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️---- total size ----❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️" >> android_size_$apkpath.log
du -sh  $apkpath >>android_size_$apkpath.log
du -sh  apk >>android_size_$apkpath.log
echo "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️---- pic ----❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️" >> android_size_$apkpath.log

du -a -h  apk/* | grep -E 'svg|png|jpg|gif' |grep [1-9]M |sort -r -n -t " "| sed -n '1,30p' >> android_size_$apkpath.log
du  -h -a apk/* | grep -E 'svg|png|jpg|gif' |sort -r -n -t " "|sed -n '1,30p' >> android_size_$apkpath.log

echo "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️---- other files ----❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️" >> android_size_$apkpath.log

du  -h -a  apk/* | grep "M" | grep -v "K"| grep -v  -E  'svg|png|jpg|gif|/com$|/data$|/google$|/i18n$|/phonenumbers$|/lombok$|/xml$|/arm64-v8a$|/res$|/bin$|/drawable-nodpi-v4$|/x86$|/x86_64$|/ffmpeg$|/bgm$|/drawable-hdpi-v4$|/drawable-xhdpi-v4$|/drawable-mdpi-v4$|/drawable-xxhdpi-v4$|/drawable-xhdpi$|/drawable-xhdpi$|/lib$|/raw$|/layout$|/drawable$|/menu$|/armeabi-v7a$|/assets$|/armeabi$|/LICENSE$|/anim$'|sort -r -n -t " "|sed -n '1,50p' >>android_size_$apkpath.log
du  -h -a  apk/* | grep "K" | grep -v "M"| grep -v  -E  'svg|png|jpg|gif|/xml$|/arm64-v8a$|/res$|/bin$|/drawable-nodpi-v4$|/x86$|/x86_64$|/ffmpeg$|/bgm$|/drawable-hdpi-v4$|/drawable-xhdpi-v4$|/drawable-mdpi-v4$|/drawable-xxhdpi-v4$|/drawable-xhdpi$|/lib$|/raw$|/layout$|/drawable$|/menu$|/armeabi-v7a$|/assets$|/armeabi$|/LICENSE$|/anim$'|sort -r -n -t " "|sed -n '1,50p' >>android_size_$apkpath.log

date_log=`date +%m_%d_%X`
echo $date_log
mkdir -p report/"$apkpath"
cp android_size_$apkpath.log ./report/"$apkpath"/android_"$date_log".log

flater_pic_m=`more android_size_$apkpath.log | grep -E 'jpg|png'|grep [0-9]M | awk -F 'M' 'NR==1 {print $1}' `
flater_pic_k=`more android_size_$apkpath.log | grep -E 'jpg|png'|grep -v M | awk -F 'K' 'NR==1 {print $1}' `

echo $flater_pic_m
echo $flater_pic_k

y=`echo "$flater_pic_m > 1"|bc`  
echo $y

z=`echo "$flater_pic_k > 1000"|bc`  
echo $z

if [[ "$y" -eq 1 || "$z" -eq 1 ]]; then
	echo ！！！！！！！图片过大报警！！！！！！ > msg.log
	echo http://ci.byted.org/view/aweme/job/UGC_package_size/ws/android_size_$apkpath.log >>msg.log
	python dingding_msg.py

fi

nowfile=`ls report/${apkpath}/  |sort |  tail -2 | sed -n 2p`
echo $nowfile
lastfile=`ls report/${apkpath}/  |sort |  tail -2 | sed -n 1p `
echo $lastfile
nowfile_size=`more report/${apkpath}/${nowfile} | awk -F 'M' 'NR == 2 {print $1}'`
echo $nowfile_size
lastfile_size=`more report/${apkpath}/${lastfile} | awk -F 'M' 'NR == 2 {print $1}'`
echo $lastfile_size
x=`echo "$nowfile_size - $lastfile_size -5"|bc`  
echo $x
w=`echo "$x > 0"|bc`  
echo $w

if [[ "$w" -eq 1 ]]; then
	echo ！！！！！！！新版本包大了5M以上啦！！！！！！ > msg.log
	echo http://ci.byted.org/view/aweme/job/UGC_package_size/ws/android_size_$apkpath.log >>msg.log
	python dingding_msg.py
fi











