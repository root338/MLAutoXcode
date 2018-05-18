#!/bin/sh
## 功能说明：可以搜索指定文件夹内的图片资源进行重命名，并重新复制到指定的目录中
## 新icon的路径
iconPath='./ios-icon'
## 需要保存的路径
targetPath='./AppIcon'
## 新文件宽度和高度的拼接符
mark='x'
## 需要设置的图片扩展名
pathExtension='.png'
# 搜索的条件
searchCondition="*${pathExtension}"

# 循环遍历 iconPath 下的图片文件
for path in $(find $iconPath -iname $searchCondition)
do

# 获取文件
# 获取png文件的高度，纯数字值
  height=$(mdls $path | grep kMDItemPixelHeight | tail -n 1 | cut -d = -f 2)
# 获取png文件的宽度, 纯数字值
  width=$(mdls $path | grep kMDItemPixelWidth | tail -n 1 | cut -d = -f 2)
# 获取png文件名
# filename=$(basename $path)
 
 name="$targetPath/$width$mark$height$pathExtension"
## 因为$value1$value2 拼接的字符串中间有空格，所以需要去除空格
 newImagePath=${name// /} 

 i=1
 while [ 1 ];
 do

  if [ ! -f $newImagePath ]; then
## 当文件路径不存在时进行移动
     echo "创建的目录路径为:" $newImagePath
     break
  fi
  name="$targetPath/$width$mark$height-$i$pathExtension"
  newImagePath=${name// /}
  
  ((i++))
 done

 cp $path $newImagePath
done
