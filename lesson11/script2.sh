#!/bin/bash

DIR="$HOME/lesson11/myfolder"
FILE2="$DIR/file2"



if [ -d "$DIR" ]; then 

# Определяет, как много файлов создано в папке myfolder
file_counter=$(ls "$DIR" | wc -l)
echo "Кол-во файлов в папке myfolder: $file_counter"

# Исправляет права второго файла с 777 на 664
if [ -f "$FILE2" ]; 
	then chmod 665 "$FILE2"
	echo "Права на файл file2 - 664"
else 
	echo "Файл file2 не существует"
fi

# Определяет пустые файлы и удаляет их
for file in "$DIR"/*; do 
	if [ -s "$file" ];
	then 
		echo "$file - Содержит данные"
		first_line=$(head -n 1 "$file")
		echo "$first_line" > "$file"
	else
		echo -e "$file - Пустой"
		rm -rf "$file"
	fi 
done
echo "Пустые файлы и все строки кроме первой были удалены "

# Удаляет все строки кроме первой в остальных файлах
else
	echo "myfolder не существует"
fi
exit 0
