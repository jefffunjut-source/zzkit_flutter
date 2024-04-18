# 用法：./deal4xImages.sh [del]

echo ''
echo 'Begin to deal 4x Pictures to 4 Size Documents'

find . -name "*DS_*" | xargs rm -rf

if [ "$1" = "del" ];then

  find img -name "*.png" | xargs rm -rf
  find img -name "*.jpg" | xargs rm -rf
  find img -name "*.jpeg" | xargs rm -rf
fi

file_count=$(find img4x -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | wc -l)
echo "total files:$file_count"
if [ $file_count = 0 ];then
  exit
fi

progress=1
for img in img4x/*
do
  if [ -f "$img"  ];then

      file_extension=$(basename "$img" | rev | awk -F. '{print tolower($1)}' | rev)
      # 判断是否为图片类型文件
      if [ "$file_extension" = "jpg" ] || [ "$file_extension" = "png" ] || [ "$file_extension" = "jpeg" ]; then

        pixW_1x=0
        pixH_1x=0
        pixW_2x=0
        pixH_2x=0
        pixW_3x=0
        pixH_3x=0
        pixW_4x=0
        pixH_4x=0
        
        my_array=($(echo $img | tr "." "\n"))
        tmp="${my_array[0]}"
        my_array=($(echo $tmp | tr "_" "\n"))
        #split string to get width and height
        for i in "${my_array[@]}"
        do
          if [ "$i" -gt 0 ] 2>/dev/null ;then 
            if [ $pixH_1x = 0 ];then
              pixH_1x=$i
              pixH_2x=`expr $pixH_1x \* 2`
              pixH_3x=`expr $pixH_1x \* 3`
              pixH_4x=`expr $pixH_1x \* 4`
            else
              pixW_1x=$i
              pixW_2x=`expr $pixW_1x \* 2`
              pixW_3x=`expr $pixW_1x \* 3`
              pixW_4x=`expr $pixW_1x \* 4`
            fi
          fi 
        done
        # 文件尾部未指定宽高的，读取图片像素设置宽高
        if [ $pixH_1x = 0 ];then
          pixW_4x=$(sips -g pixelWidth "$img" | awk '/pixelWidth:/{print $2}')
          pixH_4x=$(sips -g pixelHeight "$img" | awk '/pixelHeight:/{print $2}')
          pixW_1x=$(printf "%.0f\n" "$(echo "$pixW_4x * 0.25" | bc)")
          pixH_1x=$(printf "%.0f\n" "$(echo "$pixH_4x * 0.25" | bc)")
          pixW_2x=$(printf "%.0f\n" "$(echo "$pixW_4x * 0.5" | bc)")
          pixH_2x=$(printf "%.0f\n" "$(echo "$pixH_4x * 0.5" | bc)")
          pixW_3x=$(printf "%.0f\n" "$(echo "$pixW_4x * 0.75" | bc)")
          pixH_3x=$(printf "%.0f\n" "$(echo "$pixH_4x * 0.75" | bc)")           
        fi

      
        my_array=($(echo $img | tr "/" "\n"))
        originalImg=${my_array[1]}

        copyimg=img4x/xxxbbb

        mv $img $copyimg
        sips -z $pixH_1x $pixW_1x $copyimg -o $img > /dev/null 2>&1
        mv $img img/$originalImg
  
        sips -z $pixH_2x $pixW_2x $copyimg -o $img > /dev/null 2>&1
        mv $img img/2.0x/$originalImg
  
        sips -z $pixH_3x $pixW_3x $copyimg -o $img > /dev/null 2>&1
        mv $img img/3.0x/$originalImg
  
        mv $copyimg $img
        cp $img img/4.0x/$originalImg
  
        # 计算进度百分比
        percentage=$((progress * 100 / file_count))
        # 计算进度条长度
        bar_length=$((progress * 50 / file_count))
        # 打印进度条
        printf "[%-${bar_length}s] %d%%\r" "##################################################" "$percentage"
        progress=$progress+1
      else
        continue
      fi
  fi
done

echo ''
echo 'Done!'
echo ''