#!/bin/bash

cp /Users/ugc_test/work/*.txt .

project=$1

case $project in
	live_iOS_inhouse_dailybuild_backup2)
    rm -rf `ls | grep "txt" | grep  -v "LiveStreamingInhouse-LinkMap-normal-armv7.txt"`
    echo live_iOS_inhouse_dailybuild_backup2
    curl -o LiveStreamingInhouse.app.ipa http://ci.byted.org/view/aweme/job/live_iOS_inhouse_dailybuild_backup2/lastSuccessfulBuild/artifact/LiveStreaming/build/Release-iphoneos/LiveStreamingInhouse.app.ipa
    unzip LiveStreamingInhouse.app.ipa
    cp -r Payload/LiveStreamingInhouse.app .
    sh ios_size.sh LiveStreamingInhouse.app
	;;
	aweme_iOS_inhouse_master)
    rm -rf `ls | grep "txt" |grep  -v "AwemeInhouse-LinkMap-normal-armv7.txt"`
    echo aweme_iOS_inhouse_master
    curl -o AwemeInhouse.app.ipa http://ci.byted.org/view/aweme/job/aweme_iOS_inhouse_master/lastSuccessfulBuild/artifact/Aweme/build/Release-iphoneos/AwemeInhouse.app.ipa
    unzip AwemeInhouse.app.ipa
    cp -r Payload/AwemeInhouse.app .
    sh ios_size.sh AwemeInhouse.app
    ;;
    Essay_iOS_InHouse)
    rm -rf `ls | grep "txt" |grep  -v "JokeInhouse-LinkMap-normal-armv7.txt"`
    echo Essay_iOS_InHouse
    curl -o JokeInhouse.app.ipa http://ci.byted.org/view/aweme/job/Essay_iOS_InHouse/lastSuccessfulBuild/artifact/Essay/build/Release-iphoneos/JokeInhouse.app.ipa
    unzip JokeInhouse.app.ipa
    cp -r Payload/JokeInhouse.app .
    sh ios_size.sh JokeInhouse.app
    ;;
    live_android_alpha)
    echo live_android_alpha
    curl -o Live.apk http://ci.byted.org/view/aweme/job/live_android_alpha/lastSuccessfulBuild/artifact/livestream/release/LiveStream-release.apk
    sh android_size.sh Live.apk 
    ;;
    aweme_android_master)
    echo aweme_android_master
    curl -o Aweme.apk http://ci.byted.org/view/aweme/job/aweme_android_master/lastSuccessfulBuild/artifact/aweme/release/Aweme-release.apk
    sh android_size.sh Aweme.apk
    ;;
    Essay_Joke_android_dev)
    echo Essay_Joke_android_dev
    curl -o jokeEssay.apk http://ci.byted.org/view/neihan/job/Essay_Joke_android_dev/lastSuccessfulBuild/artifact/JokeEssay/release/jokeEssay.apk 
    sh android_size.sh jokeEssay.apk
    ;;
    
esac
rm -rf `ls | grep  "armv7"`


