all: tmp/bash-macros.m4 tmp/powershell-macros.m4 build
	cat tmp/bash-macro.m4 bash.m4  | m4 > build/dispatcherflush.sh
	cat tmp/powershell-macros.m4 powershell.m4 | m4 > build/dispatcherflush.ps1
	chmod +x build/dispatcherflush.sh
	@echo "Make sure that the host specified are configured to allow connections on the computer from which you run dispatcherflush.sh."

clean:
	rm -rf tmp
	rm -rf build

build:
	mkdir build

tmp/hostlist.txt: tmp
	@while true; do read -p "Enter Hostname and Port (blank when done): " hostport ; [[ -z "$$hostport" ]] && break ; echo $$hostport ; done > tmp/hostlist.txt

tmp/bash-macros.m4: tmp tmp/hostlist.txt
	cat tmp/hostlist.txt | awk 'BEGIN { printf("define(%cHOSTLIST%c,%c",96,39,96) } { printf("%s ",$$0) } END { printf("%c)",39) }' | sed "s| '|'|g" > tmp/bash-macro.m4

tmp/powershell-macros.m4: tmp tmp/hostlist.txt
	cat tmp/hostlist.txt | awk 'BEGIN { printf("define(%cHOSTLIST%c,%c",96,39,96) } { printf("$$hosts += \"%s\"\n",$$0) } END { printf("%c)",39) }' > tmp/powershell-macros.m4

tmp:
	mkdir tmp
