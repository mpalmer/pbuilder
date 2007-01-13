# run debuild with .git ignore.
debuild -us -uc -I.git
git push --tags
git push --all

