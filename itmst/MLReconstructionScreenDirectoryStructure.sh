#!/bin/sh

## 约定
## 解析规则
## 在屏幕快照的路径下
##
## |---- 指定的包含所有的屏幕快照目录
## ....|--- 不同语言，查看 apple 支持的语言代码 https://help.apple.com/itc/appsspec/#/itce40fff472
## .........|-----不同的屏幕快照图片，每种图片最后需要使用"-1"(例子:"*-1.png")来给定在AppStore显示的位置



## 修改重新设置屏幕快照的信息

## 原图片文件夹路径
mImagePath="/Users/apple/dev/YMAppStoreResources/YMMainApp/Screen"
## 新图片路径
mNewImagesPath="/Users/apple/YMUploadCache/Screen"

## 屏幕快照的图片格式
mImageExtension=".jpg"

mIOS_3_5_FolderName="iOS-3.5-in"
mIOS_4_FolderName="iOS-4-in"
mIOS_4_7_FolderName="iOS-4.7-in"
mIOS_5_5_FolderName="iOS-5.5-in"
mIOS_5_8_FolderName="iOS-5.8-in"
mIOSiPadFolderName="iOS-iPad"
mIOSiPadProFolderName="iOS-iPad-Pro"
mIOSiPadPro_10_5_FolderName="iOS-iPad-Pro-10.5-in"
mIOSiPadPro_12_9_FolderName="iOS-iPad-Pro-12.9-in"

if [ ! -d "${mNewImagesPath}" ];then
mkdir -p "${mNewImagesPath}"
fi

if [ ! -d "${mImagePath}" ];then
echo "${mImagePath} 不是一个有效的目录"
exit
fi

for lanuageCodeName in `ls "${mImagePath}"`
do

pLocaleScreenshotPath="${mImagePath}/${lanuageCodeName}"

if [ ! -d "${pLocaleScreenshotPath}" ];then
## 不是目录
continue
fi

## 新屏幕快照的指定语言路径
pNewLocalScreenshotPath="${mNewImagesPath}/${lanuageCodeName}"
if [ ! -d "${pNewLocalScreenshotPath}" ];then
mkdir "${pNewLocalScreenshotPath}"
fi

mIOS_3_5_Path="${pNewLocalScreenshotPath}/${mIOS_3_5_FolderName}"
mIOS_4_Path="${pNewLocalScreenshotPath}/${mIOS_4_FolderName}"
mIOS_4_7_Path="${pNewLocalScreenshotPath}/${mIOS_4_7_FolderName}"
mIOS_5_5_Path="${pNewLocalScreenshotPath}/${mIOS_5_5_FolderName}"
mIOS_5_8_Path="${pNewLocalScreenshotPath}/${mIOS_5_8_FolderName}"
mIOSiPadPath="${pNewLocalScreenshotPath}/${mIOSiPadFolderName}"
mIOSiPadProPath="${pNewLocalScreenshotPath}/${mIOSiPadProFolderName}"
mIOSiPadPro_10_5_Path="${pNewLocalScreenshotPath}/${mIOSiPadPro_10_5_FolderName}"
## mIOSiPadPro_12_9_Path="${pNewLocalScreenshotPath}/${mIOSiPadPro_12_9_FolderName}"

for path in $(find "${pLocaleScreenshotPath}" -iname "*${mImageExtension}")
do

width=$(mdls "${path}" | grep kMDItemPixelWidth | tail -n 1 | cut -d = -f 2)
height=$(mdls "${path}" | grep kMDItemPixelHeight | tail -n 1 | cut -d = -f 2)
width="${width// /}"
height="${height// /}"

fileName=$(basename ${path} ${mImageExtension})

index="${fileName##*-}"

if [[ ("${width}" == "1125" && "${height}" == "2436") || ("${width}" == "2436" && "${height}" == "1125") ]];then

## 1125 x 2436 5.8in
if [ ! -d "${mIOS_5_8_Path}" ];then
mkdir -p "${mIOS_5_8_Path}"
fi
cp "${path}" "${mIOS_5_8_Path}/screen-${lanuageCodeName}-iOS-5-8-${index}.jpg"

elif [[ ("${width}" == "640" && "${height}" == "960") || ("${width}" == "960" && "${height}" == "640") ]];then

## 640 x 960 3.5in
if [ ! -d "${mIOS_3_5_Path}" ];then
mkdir -p "${mIOS_3_5_Path}"
fi
cp "${path}" "${mIOS_3_5_Path}/screen-${lanuageCodeName}-iOS-3-5-${index}.jpg"

elif [[ ("${width}" == "640" && "${height}" == "1136") || ("${width}" == "1136" && "${height}" == "640") ]];then

## 640 x 1136 4in
if [ ! -d "${mIOS_4_Path}" ];then
mkdir -p "${mIOS_4_Path}"
fi
cp "${path}" "${mIOS_4_Path}/screen-${lanuageCodeName}-iOS-4-${index}.jpg"

elif [[ ("${width}" == "750" && "${height}" == "1334") || ("${width}" == "1334" && "${height}" == "750") ]];then

## 750 x 1334 4.7in
if [ ! -d "${mIOS_4_7_Path}" ];then
mkdir -p "${mIOS_4_7_Path}"
fi
cp "${path}" "${mIOS_4_7_Path}/screen-${lanuageCodeName}-iOS-4-7-${index}.jpg"

elif [[ ("${width}" == "1242" && "${height}" == "2208") || ("${width}" == "2208" && "${height}" == "1242") ]];then

## 1242 x 2208 5.5in
if [ ! -d "${mIOS_5_5_Path}" ];then
mkdir -p "${mIOS_5_5_Path}"
fi
cp "${path}" "${mIOS_5_5_Path}/screen-${lanuageCodeName}-iOS-5-5-${index}.jpg"

elif [[ ("${width}" == "768" && "${height}" == "1024") || ("${width}" == "1024" && "${height}" == "768") || ("${width}" == "1536" && "${height}" == "2048") || ("${width}" == "2048" && "${height}" == "1536") ]];then
## 768 x 1024 1536 x 2048 iPad
if [ ! -d "${mIOSiPadPath}" ];then
mkdir -p "${mIOSiPadPath}"
fi
cp "${path}" "${mIOSiPadPath}/screen-${lanuageCodeName}-iOS-iPad-${index}.jpg"

elif [[ ("${width}" == "1668" && "${height}" == "2224") || ("${width}" == "2224" && "${height}" == "1668") ]];then

## 1668 x 2224 iPad Pro 10.5
if [ ! -d "${mIOSiPadPro_10_5_Path}" ];then
mkdir -p "${mIOSiPadPro_10_5_Path}"
fi
cp "${path}" "${mIOSiPadPro_10_5_Path}/screen-${lanuageCodeName}-iOS-iPad-Pro-10-5-${index}.jpg"

elif [[ ("${width}" == "2048" && "${height}" == "2732") || ("${width}" == "2732" && "${height}" == "2048") ]];then

## 2048 x 2732 iPad Pro 12.9
if [ ! -d "${mIOSiPadProPath}" ];then
mkdir -p "${mIOSiPadProPath}"
fi
cp "${path}" "${mIOSiPadProPath}/screen-${lanuageCodeName}-iOS-iPad-Pro-12-9-${index}.jpg"

fi

done

done

## 生成 <software_screenshots></software_screenshots> xml 文件

