deploy:
	json -I -f _harp.json -e 'this.globals.github_pages=true'
	rm -rf www.tgz
	harp compile ./ www
	cd ./www && rm makefile && git init . && git add -A . && git commit -m "Deploy" && git push "git@github.com:poultonjoe/ATAM.git" master:gh-pages --force
	cd ..
	tar -zcvf www.tgz ./www
	rm -rf www
	json -I -f _harp.json -e 'this.globals.github_pages=false'
	git checkout _harp.json
	git add -A && git commit -m "compiled site .tgz" && git push