deploy:
	json -I -f _harp.json -e 'this.globals.github_pages=true'
	harp compile ./ www
	cd ./www && rm makefile && git init . && git add -A . && git commit -m "Deploy" && git push "git@github.com:poultonjoe/ATAM.git" master:gh-pages --force
	cd ..
	rm -rf www
	json -I -f _harp.json -e 'this.globals.github_pages=false'
	git checkout _harp.json