#!/bin/sh

DIRECTORY="/var/repos/wp.git"

if [ ! -d "$DIRECTORY" ]; then
	cd /var
	mkdir repos
	cd repos
	mkdir wp.git
	cd wp.git
	git init --bare
	cd /var

	cd /var/repos/wp.git/hooks

	touch post-receive
	chmod +x post-receive
	FILE=post-receive
	echo "#!/bin/sh" > $FILE
	echo "GIT_WORK_TREE=/var/www/html/wordpress git checkout -f" >> $FILE

	cd /
fi