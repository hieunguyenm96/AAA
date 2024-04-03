
run:
	docker run -it --rm --name external-script-with-kamailio -v "/Users/minhhieu/Projects/local/AAA/scripts":/usr/src/myapp -w /usr/src/myapp perl:5.34 bash
	