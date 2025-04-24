ps -eo pid,rss,comm --sort=-rss | head -n 2 && echo "---" && top -b -n 1 -o %MEM | head -n 1
