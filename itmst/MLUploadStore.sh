#!/bin/sh

## 生成 iTMSTransporter 的 metadata.xml 文件，以下简称 xml
## https://help.apple.com/itc/appsspec/#/
## xml 生成的路径
#mFolderPath="."

## 资源目录
mUploadResoucesPath="/Users/apple/YMUploadResouces"
## 提交的账号密码目录
mItunesAccountExportShell="/Users/apple/ExportAccount/iTunesConnectAccount.sh"

## xml 文件名
mMetadataFileName="metadata.xml"

##--------------------------------------------------------
## xml 内部数据的数据

## xmlns version 版本
mPackageVersion="software5.9"

## 团队信息
## teamid(团队id)/shortname(短名称) 两者必须存在一个
mItemId=`cat "${mUploadResoucesPath}/itemId"`
mShortName=

## app 信息
## app SKU 值
mVendorId=`cat "${mUploadResoucesPath}/vendorId"`

## 可选值，元数据适用的平台，可用的值 ios/osx/appletvos
mAppPlatform="ios"

## verisons 块 尚未交付新语言或更新现有语言区，则无需 versions
mCreateVersions="YES"
## 版本 当versions存在时，必填
mVersion="6.4.2"

## locales 块，只在更新/添加时使用
mCreateLocales="YES"

## 语言区具体定义
## 支持的语言区
mLocaleList=("zh-Hans" "en-AU" "en-GB")
## 各个语言区的标题, 必须和mLocaleList的长度一样
mLocaleTitleList=("悦美-整形优惠特卖" "悦美-整形优惠特卖" "悦美-整形优惠特卖")
## 各个语言区的副标题, 必须和mLocaleList长度一样，如果忽略使用 ""
mLocalSubtitleList=("" "" "")
## 各个语言区的描述, 首次提交时为必填项，其他情况可选
mLocalDescriptionList=("" "" "")
## 各个语言区的宣传文本，每个宣传文本不能超过170个字符, iOS 11 以上支持
mLocalPromotionalList=("" "" "")
## 各个语言区的关键词，关键词为多个单词的数组组成 长度 100 以内
## 首次提交为必填项，其他情况可选
mLocalKeywordsList=("" "" "")
## 各个语言区新增内容文本
## 新版app不需要该值，后续版本才需要该值，长度范围 [4, 4000]
mLocalVersionWhatsNewList=("" "" "")
## 各个语言区营销网址URL
## 可选，每个URL长度必须[2, 255]字符, 需要移除填写字符串"remove"
mLocalSoftwareURLList=("" "" "")
## 隐私政策网址URL
## 如果app包含自动续期订阅app内购买项目在首次提交新语言时为必填项, 需要移除填写"remove"
mLocalPrivacyURLList=("" "" "")
## 技术支持网址URL
## 首次提交新语言时为必填项，[2,255]
mLocalSupportURLList=("" "" "")
## 各个语言区的屏幕快照
## 添加屏幕快照字符说明: "add"(添加)/"remove"(移除)/(其他不添加)
mLocalSoftwareScreenshotsList=("add" "" "")
mIsUploadSoftwareScreenshots="YES"

## 上传时的临时路径
mUploadTmpPath="/Users/apple/YMUploadCache"

## 屏幕快照的路径
mLocalSoftwareScreenshotsPath="${mUploadTmpPath}/Screen"


##--------------------------------------------------------
####### 保存 itmsp 缓存目录
mSoftwareStorePackagesPath="${mUploadTmpPath}/Itmsp"

## 数据包的扩展
mStoreExtension="itmsp"

##--------------------------------------------------------
#######生成文件

if [ "${mIsUploadSoftwareScreenshots}" == "YES" ];then
sh "MLReconstructionScreenDirectoryStructure.sh"
fi

## store数据包路径
mSoftwareStorePackagePath="${mSoftwareStorePackagesPath}/${mVendorId}.${mStoreExtension}"

## metadata.xml 路径
mMetadataFilePath="${mSoftwareStorePackagePath}/${mMetadataFileName}"

if [ ! -d "${mSoftwareStorePackagePath}" ];then
mkdir -p "${mSoftwareStorePackagePath}"
fi

## 约定
## 必须的选项使用 *!
## 在一定条件下的必须内容使用 *?!

## *! 写入xml声明
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "${mMetadataFilePath}"

## *! xmlns (XML 命名空间)属性为必填项，该属性用于声明xml中的标签和属性应遵照的命名空间。
## *! 命名空间必须是: http://apple.com/itunes/importer
##
echo "<package xmlns=\"http://apple.com/itunes/importer\" version=\"${mPackageVersion}\">" >> "${mMetadataFilePath}"

if [ -z "${mShortName}" -a -z "${mItemId}" ];then
    echo "mShortName mItemId 不能同时为空"
    exit
fi

## *?! 写入shortName, 与 itemId 必须存在一个
if [ -n "${mShortName}" ];then
    echo "<provider>${mShortName}</provider>" >> "${mMetadataFilePath}"
fi

## *?! 写入 itemid， 与 shourtName 必须存在一个
if [ -n "${mItemId}" ];then
    echo "<team_id>${mItemId}</team_id>" >> "${mMetadataFilePath}"
fi

## *! 软件元素块，每个数据包只能定义一个软件元素
echo "<software>" >> "${mMetadataFilePath}"

## *! App SKU 长度 [2, 100]
if [ -z "${mVendorId}" ];then
    echo "mVendorId App SKU 值不能为空"
    exit
fi
echo "<vendor_id>${mVendorId}</vendor_id>" >> "${mMetadataFilePath}"

## *! 软件元数据
if [ -n "${mAppPlatform}" ];then
echo "<software_metadata app_platform=\"${mAppPlatform}\">" >> "${mMetadataFilePath}"
else
echo "<software_metadata>" >> "${mMetadataFilePath}"
fi

if [ "${mCreateVersions}" == "YES" ];then
## 添加版本
echo "<versions>" >> "${mMetadataFilePath}"

## 版本
if [ -n "${mVersion}" ];then
echo "<version string=\"${mVersion}\">" >> "${mMetadataFilePath}"

if [ "${mCreateLocales}" == "YES" ];then
echo "<locales>" >> "${mMetadataFilePath}"

## 判读本地化设置的数组长度

if [ "${#mLocaleList[*]}" != "${#mLocaleTitleList[*]}" -o "${#mLocaleList[*]}" != "${#mLocalSubtitleList[*]}" ];then
echo "mLocaleList, mLocaleTitleList, mLocalSubtitleList 数组长度必须相同"
exit
fi

mLocaleListTotal="${#mLocaleList[*]}"
for ((index = 0; index < "${mLocaleListTotal}"; index++))
do

p_locale="${mLocaleList[${index}]}"
p_title="${mLocaleTitleList[${index}]}"
p_subtitle="${mLocalSubtitleList[${index}]}"
p_description="${mLocalDescriptionList[${index}]}"
p_promotional="${mLocalPromotionalList[${index}]}"
p_keywords="${mLocalKeywordsList[${index}]}"
p_version_whats_new="${mLocalVersionWhatsNewList[${index}]}"
p_software_url="${mLocalSoftwareURLList[${index}]}"
p_privacy_url="${mLocalPrivacyURLList[${index}]}"
p_support_url="${mLocalSupportURLList[${index}]}"
p_screenshot_type="${mLocalSoftwareScreenshotsList[${index}]}"

echo "<locale name=\"${p_locale}\">" >> "${mMetadataFilePath}"

if [ -z "${p_title}" ];then
echo "本地化 ${p_locale} 下的 标题不能为空"
exit
else
if [ "${#p_title}" -lt 2 -o "${#p_title}" -gt 50 ];then
echo "本地化 ${p_locale} 下的 标题不能少于2个字符，且不能大于50个字符，当前为${#p_title}字"
exit
fi
fi

if [ -n "${p_subtitle}" ];then
if [ "${#p_subtitle}" -gt 30 ];then
echo "本地化${p_locale}下的副标题不能超过30个字符, 当前为${#p_subtitle}字"
exit
fi
fi

if [ "${#p_promotional}" -gt 170 ];then
echo "本地化${p_locale}下的 宣传文本不能超过170字, 当前为 ${#p_promotional} 字"
exit
fi

if [ -n "${p_version_whats_new}" ];then
if [ "${#p_version_whats_new}" -lt 4 -o "${#p_version_whats_new}" -gt 4000 ];then
echo "本地化${p_locale}下的，新增内容不能小于 4 个字符，且不能超过 4000, 当前为${#p_version_whats_new} 字"
exit
fi
fi

if [ -n "${p_software_url}" ];then
if [ "${#p_software_url}" -lt 2 -o "${#p_software_url}" -gt 255 ];then
echo "本地化${p_locale}下的，营销网址不能小于 2 个字符，且不能超过 255, 当前为${#p_software_url} 字"
exit
fi
fi

if [ -n "${p_support_url}" ];then
if [ "${#p_support_url}" -lt 2 -o "${#p_support_url}" -gt 255 ];then
echo "本地化${p_locale}下的，支持网址不能小于 2 个字符，且不能超过 255, 当前为${#p_software_url} 字"
fi
fi

if [ -n "${p_privacy_url}" ];then
if [ "${#p_privacy_url}" -lt 2 -o "${#p_privacy_url}" -gt 255 ];then
echo "本地化${p_locale}下的，隐私政策网址不能小于 2 个字符，且不能超过 255, 当前为${#p_software_url} 字"
fi
fi

## 写入标题
echo "<title>${p_title}</title>" >> "${mMetadataFilePath}"
## 写入副标题
if [ -n "${p_subtitle}" ];then
echo "<subtitle>${p_subtitle}</subtitle>" >> "${mMetadataFilePath}"
fi
## 写入描述
if [ -n "${p_description}" ];then
echo "<description>${p_description}</description>" >> "${mMetadataFilePath}"
fi
## 写入宣传文本
if [ -n "${p_promotional}" ];then
echo "<promotional_text>${p_promotional}</promotional_text>" >> "${mMetadataFilePath}"
fi

## 写入 keywords
if [ -n "${p_keywords}" ];then

echo "<keywords>" >> "${mMetadataFilePath}"

echo "<keyword>${p_keywords}</keyword>" >> "${mMetadataFilePath}"

echo "</keywords>" >> "${mMetadataFilePath}"

fi

## 写入 新增内容
if [ -n "${p_version_whats_new}" ];then
echo "<version_whats_new>${p_version_whats_new}</version_whats_new>" >> "${mMetadataFilePath}"
fi

## 写入营销网址
if [ -n "${p_software_url}" ];then
if [ "${p_software_url}" == "remove" ];then
echo "<software_url></software_url>" >> "${mMetadataFilePath}"
else
echo "<software_url>${p_software_url}</software_url>" >> "${mMetadataFilePath}"
fi
fi

## 写入隐私政策网址
if [ -n "${p_privacy_url}" ];then
if [ "${p_privacy_url}" == "remove" ];then
echo "<privacy_url></privacy_url>" >> "${mMetadataFilePath}"
else
echo "<privacy_url>${p_privacy_url}</privacy_url>" >> "${mMetadataFilePath}"
fi
fi

## 写入技术支持网址
if [ -n "${p_support_url}" ];then
echo "<support_url>${p_support_url}</support_url>" >> "${mMetadataFilePath}"
fi

## 判断屏幕快照处理方式
if [ "${p_screenshot_type}" == "remove" ];then

echo "<software_screenshots></software_screenshots>" >> "${mMetadataFilePath}"

elif [ "${p_screenshot_type}" == "add" ];then

mLocalScreenshotPath="${mLocalSoftwareScreenshotsPath}/${p_locale}"
if [ ! -d "${mLocalScreenshotPath}" ];then
echo "本地化${p_locale}下的，屏幕快照路径不存在/或不是目录${mLocalScreenshotPath}"
exit
fi

echo "<software_screenshots>" >> "${mMetadataFilePath}"

## 写入屏幕快照信息
for pDisplayTarget in `ls "${mLocalScreenshotPath}"`
do

pTargetDisplayScreenshotPath="${mLocalScreenshotPath}/${pDisplayTarget}"

for pTargetDisplayScreenshotName in `ls ${pTargetDisplayScreenshotPath}`
do

pTargetDisplayScreenshotPosition="${pTargetDisplayScreenshotName%%.*}"
pTargetDisplayScreenshotPosition="${pTargetDisplayScreenshotPosition##*-}"

pTargetDisplayScreenshotImagePath="${pTargetDisplayScreenshotPath}/${pTargetDisplayScreenshotName}"

pTargetDisplayScreenshotImageMD5Value=`md5 "${pTargetDisplayScreenshotImagePath}" | cut -d = -f 2`
pTargetDisplayScreenshotImageMD5Value="${pTargetDisplayScreenshotImageMD5Value// /}"

pTargetDisplayScreenshotImageSizeValue=`mdls "${pTargetDisplayScreenshotImagePath}" | grep kMDItemLogicalSize | tail -n 1 | cut -d = -f 2`
pTargetDisplayScreenshotImageSizeValue="${pTargetDisplayScreenshotImageSizeValue// /}"

if [ -z "${pTargetDisplayScreenshotImageSizeValue}" ];then
echo "没有获取到${pTargetDisplayScreenshotImagePath}路径下的图片大小"
exit
fi

echo "<software_screenshot display_target=\"${pDisplayTarget}\" position=\"${pTargetDisplayScreenshotPosition}\">" >> "${mMetadataFilePath}"
## 快照文件名
echo "<file_name>${pTargetDisplayScreenshotName}</file_name>" >> "${mMetadataFilePath}"
## 快照大小
echo "<size>${pTargetDisplayScreenshotImageSizeValue}</size>" >> "${mMetadataFilePath}"
## 快照MD5
echo "<checksum type=\"md5\">${pTargetDisplayScreenshotImageMD5Value}</checksum>" >> "${mMetadataFilePath}"
## 复制照片到itmsp目录下
cp "${pTargetDisplayScreenshotImagePath}" "${mSoftwareStorePackagePath}/${pTargetDisplayScreenshotName}"

echo "</software_screenshot>" >> "${mMetadataFilePath}"

done

done

echo "</software_screenshots>" >> "${mMetadataFilePath}"

fi

echo "</locale>" >> "${mMetadataFilePath}"
done

echo "</locales>" >> "${mMetadataFilePath}"
fi

echo "</version>" >> "${mMetadataFilePath}"
fi

echo "</versions>" >> "${mMetadataFilePath}"
fi

echo "</software_metadata>" >> "${mMetadataFilePath}"

echo "</software>" >> "${mMetadataFilePath}"

echo "</package>" >> "${mMetadataFilePath}"

sh "${mItunesAccountExportShell}"

## 验证数据包
iTMSTransporter -m verify -f "${mSoftwareStorePackagesPath}" -u @env:username -p @env:password -v eXtreme

## 上传数据包
#iTMSTransporter -m upload -f "${mSoftwareStorePackagesPath}" -u @env:username -p @env:password -v eXtreme

#rm -fr "${mUploadTmpPath}"
