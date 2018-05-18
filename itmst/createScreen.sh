#!/bin/sh

mSreenPath="/Users/apple/Documents/Screen/zh-Hans/iOS-5.5-in/screen-zh-Hans-iOS-5-5-2.jpg"

imageSize=`mdls "${mSreenPath}" | grep kMDItemPhysicalSize | tail -n 1 | cut -d = -f 2`
imageSize="${imageSize// /}"

imageMD5Value=`md5 "${mSreenPath}" | cut -d = -f 2`
imageMD5Value="${imageMD5Value// /}"

echo "${imageMD5Value}-${imageMD5Value}"
echo "${imageSize}-${imageSize}"

