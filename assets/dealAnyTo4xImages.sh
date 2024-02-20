# 用法：./dealAnyTo4xImages.sh $width $height

echo ''
echo 'Begin to deal Any Pictures to 4x'

find . -name "*DS_*" | xargs rm -rf

if [ "a$1" = "a" ];then
  echo '带上宽高参数'
  exit
fi

file_count=$(find imgAnyTo4x -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | wc -l)
echo "total files:$file_count"

if [ $file_count = 0 ];then
  exit
fi

i=1
for img in imgAnyTo4x/*
do
  if [ -f "$img"  ];then

      file_extension=$(basename "$img" | rev | awk -F. '{print tolower($1)}' | rev)
      
      # 判断是否为图片类型文件
      if [ "$file_extension" = "jpg" ] || [ "$file_extension" = "png" ] || [ "$file_extension" = "jpeg" ]; then
        pixW_1x=$1
        pixH_1x=$2

        my_array=($(echo $img | tr "/" "\n"))
        originalImg=${my_array[1]}

        pixW_4x=$(printf "%.0f\n" "$(echo "$pixW_1x * 4" | bc)")
        pixH_4x=$(printf "%.0f\n" "$(echo "$pixH_1x * 4" | bc)")

        sips -z $pixH_4x $pixW_4x $img -o $img > /dev/null 2>&1
        mv $img img4x/$originalImg

        # 计算进度百分比
        percentage=$((i * 100 / file_count))
        # 计算进度条长度
        bar_length=$((i * 50 / file_count))
        # 打印进度条
        printf "[%-${bar_length}s] %d%%\r" "##################################################" "$percentage"
        i=$i+1
      else
        continue
      fi
  fi
done

echo 'Done!'
echo ''

if [ "a$3" = a ];then

  ./deal4xImages.sh

fi