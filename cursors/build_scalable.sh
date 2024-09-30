#!/bin/bash

# layout based on breeze theme: https://invent.kde.org/plasma/breeze/-/tree/master/cursors/Breeze/Breeze/cursors_scalable
# inkscape flags: https://inkscape.org/doc/inkscape-man.html

cd "$( dirname "${BASH_SOURCE[0]}" )"
src="src"
raw_svg="$src/cursors.svg"
aliases="$src/cursorList"
input_metadata="$src/cursors_scalable"
output_base="Sweet-cursors"
output_scalable="$output_base/cursors_scalable"

mkdir -p $output_base

# copy metadata files to output directory
cp -R $input_metadata $output_scalable

# export plain cursors
for cursor_config in $src/config/*.cursor; do
    cursor_name=$(basename "${cursor_config}" .cursor)

	echo -ne "\033[0KExporting svg cursor... $cursor_name\\r"

    output_path="$output_scalable/$cursor_name/$cursor_name.svg"
    if [[ ! -e $output_path ]]; then
        inkscape $raw_svg -i $cursor_name -l -o $output_path
    fi
done
echo -e "\033[0KExport svg cursor... DONE\\r"

# export animated cursors
for i in {01..23}
do
	echo -ne "\033[0KExporting animated cursors... $i / 23 \\r"

    cursor_name="progress"
    cursor_filename=$cursor_name-$i
    output_path="$output_scalable/$cursor_name/$cursor_filename.svg"
    if [[ ! -e $output_path ]]; then
        inkscape $raw_svg -i $cursor_filename -l -o $output_path
    fi

    cursor_name="wait"
    cursor_filename=$cursor_name-$i
    output_path="$output_scalable/$cursor_name/$cursor_filename.svg"
    if [[ ! -e $output_path ]]; then
        inkscape $raw_svg -i $cursor_filename -l -o $output_path
    fi
done
echo -e "\033[0KExport animated cursors... DONE"

# TODO: needs actual check
echo -ne "Generating shortcuts...\\r"
while read alias ; do
	ln_name=${alias% *}
	cursor_name=${alias#* }

    ln_path="$output_scalable/$ln_name"
    cursor_path="$output_scalable/$cursor_name/$cursor_name.svg"

	if [ -e "$ln_path" ] ; then
		continue
	fi

	ln -s "$cursor_path" "$ln_path"
done < $aliases
echo -e "\033[0KGenerating shortcuts... DONE"

echo -ne "Copying theme index...\\r"
	cp -R "$src/index.theme" "$output_base/index.theme"
echo -e "\033[0KCopying theme index... DONE"

echo "COMPLETE!"
