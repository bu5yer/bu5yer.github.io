#!/bin/bash

# build file
gitbook build .

# mv generated files from _book to github
mv ./_book/* ./github

# upload change to github
cd github
rm -rf !(.git)
git add .
git commit -m $1
git push
