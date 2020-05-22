#!/bin/sh

## 使用双引号的原因：防止目录中存在空格等会截断的路径而导致错误

## 项目 .xcworkspace 路径
mProjectXCWorkSpacePath="/Users/apple/dev/yuemeiProject/YMMainApp/QuickAskCommunity/QuickAskCommunity.xcworkspace"

## 项目 target 名字
mTargetName=QuickAskCommunity

## 打包类型 Debug, Release 等
mBuildType=Release

## 生成文件的总目录，该文件包含生成的 .xcarchive, 导出的 .ipa 文件
mProjectExportFolderPath="/Users/apple/Documents/TestArchive"

## 导出的 .xcarchive 所在目录名
mArchiveFolderName="Archives"

## 导出的 .ipa 文件所在目录名
mIpaFolderName="IPAs"

## 导出的编译日志输出目录名
mBuildLogFolderName="BuildLog"

## 打包生成的 .xcarchive 文件存储路径
mArchivePath="${mProjectExportFolderPath}/${mArchiveFolderName}"

## 导出 .ipa 包的路径
mProjectIPAPath="${mProjectExportFolderPath}/${mIpaFolderName}"

## 输出日志路径
mBuildLogFolderPath="${mProjectExportFolderPath}/${mBuildLogFolderName}"

## exportOptionsPlist 路径
mOptionsPlist=./exportOptionsPlistADHoc.plist

## 当前时间
mDate=`date +%Y-%m-%d\ %H-%M-%S`

## .xcarchive 文件完整路径
mArchivePath="${mArchivePath}/${mTargetName}${mDate}.xcarchive"
## .ipa 文件夹完整路径
mProjectIPAPath="${mProjectIPAPath}/${mTargetName} ${mDate}"

## .ipa 文件路径
mProjectIPAFilePath="${mProjectIPAPath}/${mTargetName}.ipa"

## 输出日志完整路径
mBuildLogPath="${mBuildLogFolderPath}/${mTargetName} ${mDate}.log"

echo "xcodebuild.sh"
echo "Project workspace path :${mProjectXCWorkSpacePath}"
echo "target name: ${mTargetName}"
echo "build type : ${mBuildType}"

echo "clean cache"

## 进行输出重定向时，输出的文件所在的目录必须先存在
##if [ ! -d "${mBuildLogFolderPath}" ];then
## 判断目录是否存在，不存在创建目录
## 如果输出日志文件所在的文件夹不存在就创建
mkdir -p "${mBuildLogFolderPath}"

##fi

## 清除指定类型的缓存
xcodebuild clean -workspace "${mProjectXCWorkSpacePath}" -scheme "${mTargetName}" -configuration ${mBuildType} >> "${mBuildLogPath}"

echo "build/export .xcarchive ..."

## 打包生成 .xcarchive 文件，并导出到指定的目录中
xcodebuild archive -workspace "${mProjectXCWorkSpacePath}" -scheme "${mTargetName}" -archivePath "${mArchivePath}" -configuration ${mBuildType} >> "${mBuildLogPath}"

echo "export .ipa ..."

## 从 .xcarchive 文件导出 .ipa 文件
xcodebuild -exportArchive -archivePath "${mArchivePath}" -exportPath "${mProjectIPAPath}" -exportOptionsPlist "${mOptionsPlist}" >> "${mBuildLogPath}"

## 错误时，尾部错误提示
mErrorLogInfo="Log Path: ${mBuildLogPath}"

if [ -d "${mArchivePath}" ]; then

## 如果 .xcarchive 导出成功
    echo "export .xcarchive success，path: ${mArchivePath}"

    if [ -d "${mProjectIPAPath}/" ]; then

## 如果 .ipa 文件导出成功
        echo "export .ipa success, path: ${mProjectIPAPath}"
        echo "Log Path: ${mBuildLogPath}"

        echo "upload to pgyer"
#        curl -F "file=@${mProjectIPAFilePath}" -F "uKey=4ab178f2c28e203e00c41debc7ca3cec" -F "_api_key=1cb430eacccc26edb8e353a3f1ee21c9" https://qiniu-storage.pgyer.com/apiv1/app/upload


        echo "end"
    else
        echo "export .ipa faild，${mErrorLogInfo}"
    fi

else
    echo "export .xcarchive faild, ${mErrorLogInfo}"

fi
