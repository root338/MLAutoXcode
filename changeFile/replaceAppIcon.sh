#!/bin/sh

#replace app Icon
#bug 不支持文件带有空格

# 新 icon 文件目录
newIconFolder='./ios-icon'

# 需要替换的项目 icon 的文件目录
projectIconFolder='/Users/apple/dev/yuemeiProject/YMMainApp/QuickAskCommunity/QuickAskCommunity/Images.xcassets/AppIcon.appiconset'

# 需要搜索的文件扩展名
pathExtension='.png'
# 搜索的条件
searchCondition="*${pathExtension}"

mark='x'
echo $searchCondition
for projectIconPath in $(find $projectIconFolder -iname $searchCondition);
do

 # 获取文件的属性
 height=$(mdls ${projectIconPath} | grep kMDItemPixelHeight | tail -n 1 | cut -d = -f 2 | cut -c 2-)
 width=$(mdls ${projectIconPath} | grep kMDItemPixelWidth | tail -n 1 | cut -d = -f 2 | cut -c 2-)

 projectIconPixel=${width}${mark}${height}

echo "${projectIconPath} : ${projectIconPixel}"
# 循环遍历新 icon 目录中与项目 icon 像素一样的图片
 for newIconPath in $(find ${newIconFolder} -iname $searchCondition);
 do

  newIconHeight=$(mdls ${newIconPath} | grep kMDItemPixelHeight | tail -n 1 | cut -d = -f 2 | cut -c 2-)
  newIconWidth=$(mdls ${newIconPath} | grep kMDItemPixelWidth | tail -n 1 | cut -d = -f 2 | cut -c 2-)

  newIconPixel=${newIconWidth}${mark}${newIconHeight}

echo "\t${newIconPath} : ${newIconPixel}"
  if [ $newIconPixel == $projectIconPixel ]
  then
   cp $newIconPath $projectIconPath
   echo "循环结束"
   break
  fi
 done

done

echo "全部结束"
