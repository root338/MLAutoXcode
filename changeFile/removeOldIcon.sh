#!/bin/sh
## 移除指定目录下的指定扩展名文件
## 需要移除文件的文件夹
removePathFolder='./AppIcon'
## 需要移除的文件扩展
removeTargetPathExtension='.png'

## 搜索并遍历所有满足文件
for filePath in $(find $removePathFolder -iname '*.png');
do
## 移除文件
 resultValue=$(rm $filePath)

done
