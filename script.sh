#!/bin/sh
 
INITIAL_COMMIT=ce30d45
START_COMMIT=`git log --before="last week" --pretty=format:%H|head -n1`
ALL_NAMES=`git log $INITIAL_COMMIT.. --pretty=format:%an|sort|uniq`
OLD_NAMES=`git log $INITIAL_COMMIT..$START_COMMIT --pretty=format:%an|sort|uniq`
echo "$OLD_NAMES">names_old.txt
echo "$ALL_NAMES">names_all.txt
diff names_old.txt names_all.txt
#rm names_old.txt names_all.txt

while read name; do
    COMMIT=$(git log --author="$name" --pretty=oneline | head -1 | awk '{print $1}');
    username=$(git rev-list --all --not $COMMIT^@ --children | grep "^$COMMIT"| xargs git show | grep "Auto" | sed "s/^.*Auto merge of \#[0-9]* - //" | sed "s/\:.*$//")
    echo "- [$name](https://github.com/$username)"
done < <(comm -23 names_all.txt names_old.txt)