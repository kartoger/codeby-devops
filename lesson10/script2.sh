#!/bin/bash
if [ -d ~/lesson10/myfolder ]; then 
# Определяет, как много файлов создано в папке myfolder
cnt=$(ls ~/lesson10/myfolder/ | wc -l)
echo "Кол-во файлов в папке myfolder: $cnt"

# Исправляет права второго файла с 777 на 664
if [ -f "myfolder/file2" ]; 
	then chmod 665 myfolder/file2
	echo "Права на файл file2 - 664"
else 
	echo "Файл file2 не существует"
fi

# Определяет пустые файлы и удаляет их
for i in myfolder/*; do 
	if [ -s $i ];
	then 
		echo "$i - Содержит данные"
		temp=$(head -n 1 "$i")
		echo $temp > $i
	else
		echo -e "$i - Пустой"
		rm -rf "$i"
	fi 
done
echo "Пустые файлы и все строки кроме первой были удалены "

# Удаляет все строки кроме первой в остальных файлах
else
	echo "myfolder не существует"
fi

