SHELL=/bin/bash

lint: 
	shellcheck *.sh && echo "No lint issues"
	
