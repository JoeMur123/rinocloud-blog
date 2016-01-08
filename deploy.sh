git add .
git commit -m "edit"
git push origin master
git add _site && git commit -m "Initial dist subtree commit"
git subtree push --prefix _site origin gh-pages
