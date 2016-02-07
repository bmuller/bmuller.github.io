#!/bin/bash
if [ "$1" == "" ]; then
    echo "Usage:"
    echo "$> $0 <title>"
    exit 1
fi

FILE=./_posts/$(date +%F)-$(echo $1 | tr [A-Z] [a-z] | sed -e 's/ /-/g' | sed -e 's/\//-/g' | sed -e "s/'//g").markdown
echo "---" > $FILE
echo "layout: post" >> $FILE
echo "title: \"$1\"" >> $FILE
echo "date: $(date +"%F %H:%M")" >> $FILE
echo "categories: []" >> $FILE
echo "---" >> $FILE
touch $FILE
git add $FILE
emacs -nw $FILE
