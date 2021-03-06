#  _    _
# | |_ | |_  ___  ___  ___    _ _ _  ___  ___    _____       ___  ___  _ _
# |  _||   || -_||  _|| -_|  | | | || .'||_ -|  |     |     |   ||   || | |
# |_|  |_|_||___||_|  |___|  |_____||__,||___|  |_|_|_|_____|_|_||_|_||_  |
#                                                     |_____|         |___|
#
# Solution for CSCI 232 Homework 1
# Usage: h1.sh submissions.tar.gz solution keyword
# More in README.md
#
# Created by m_nny, Alibek Manabayev
# Alibek.manabayev@gmail.com
# Copyright 2018. All rights reserved.

# Done
# Steps 1 .. 6
# TODO
# some format

if [[ $# -ne 3 ]]; then
	echo "Usage: $0 submissions.tar.gz solution keyword"
	exit 1
fi

submissions=$1
solution=$2
keyword=$3

copies_dir="Exact copies"
refed_dir="Referenced"
orig_dir="Original"
tmp_dir="_tmp_"
report_file="report.txt"
result_file="results-$(date +%Y%m%d).tar.gz"

copies_cnt=0
refed_cnt=0
orig_cnt=0

mkdir -p $tmp_dir
tar -xf $submissions -C $tmp_dir
mkdir -p "$copies_dir" "$refed_dir" "$orig_dir"

for file in $tmp_dir/*
do
	if cmp -s "$file" "$solution"; then
		# echo "$file: same"
		mv "$file" "$copies_dir"
		let copies_cnt+=1
	else
		if grep -q "$keyword" "$file"; then
			# echo "$file: has citation"
			mv "$file" "$refed_dir"
			let refed_cnt+=1
		else
			# echo "$file: is original"
			mv "$file" "$orig_dir"
			let orig_cnt+=1
		fi
	fi
done

# orig_ratio=$(echo "scale=2;$orig_cnt/($orig_cnt+$refed_cnt+$copies_cnt)" | bc -l)
orig_ratio=$(( 100 * $orig_cnt / ($orig_cnt + $refed_cnt + $copies_cnt) ))
echo "Exact copies  $copies_cnt"		>  $report_file
echo "Referenced    $refed_cnt"			>> $report_file
echo "Original      $orig_cnt"			>> $report_file
echo "Ratio         ${orig_ratio}%"	>> $report_file

tar -czf "$result_file" "$copies_dir" "$refed_dir" "$orig_dir" "$solution" "$report_file"

rm -rf "$copies_dir" "$refed_dir" "$orig_dir" "$tmp_dir"
rm -f "$submissions" "$solution" "$report_file"
