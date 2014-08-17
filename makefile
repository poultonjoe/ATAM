deploy:
	harp compile ./ www
	cd ./www && git init . && git add -A . && git commit -m "Deploy" && git push "git@github.com:poultonjoe/ATAM.git" master:gh-pages --force
	cd ..
	rm -rf www