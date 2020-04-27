#!/bin/bash
cd src
OS="13.4.1"

declare -a devices=(
    "iPad Pro (11-inch)"
    "iPad Pro (9.7-inch)"
    "iPhone 11"
    "iPhone 11 Pro"
    "iPhone 8"
    "iPhone SE (1st generation)"
    "iPhone SE (2nd generation)"
)

for device in "${devices[@]}"
do
    xcodebuild test \
    -enableCodeCoverage YES \
    -workspace MQTTAnalyzer.xcworkspace \
    -scheme MQTTAnalyzer \
    -destination "platform=iOS Simulator,name=$device,OS=$OS"

    if [ $? -eq 0 ]
    then
        echo "$device is okay :)"
    else
        echo "Failed for $device"
        exit 1
    fi 
done