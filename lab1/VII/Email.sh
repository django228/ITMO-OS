grep -Eroh '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.com' /etc/ | tr '\n' ',' > emails.lst
cat emails.lst
