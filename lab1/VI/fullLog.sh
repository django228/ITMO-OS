grep -E 'Warning|Information' /var/log/Xorg.0.log 2>/dev/null | \
sed -e 's/Warning/!!!WARNING!!!/g' -e 's/Information/---INFO---/g' | \
sort > full.log

cat full.log
