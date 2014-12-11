DEPLOYMENT_REPO=tomhelmer.github.io

all: server

build: dist

help:
	@echo "Available targets:"
	@echo " server - serves up site locally (default target)"
	@echo " build - build the content for deployment in ${DEPLOYMENT_REPO}"

view:
	# open front page in browser
	open http://localhost:1313

server: clean
	# Server the site up locally
	open http://localhost:1313 && hugo server -w --theme=ago --buildDrafts=true

clean:
	# clean out the local server build artifacts
	-rm -r public/*

publish:
	(cd ${DEPLOYMENT_REPO}; git add . ; git commit -m "Publish changes"; git push)

dist: dist-clean
	# Build the project for publishing
	hugo -s . --theme=ago -d ${DEPLOYMENT_REPO}

dist-clean:
	# clean publishing output dir
	# NB: Avoid removing the .git folder
	-rm -r ${DEPLOYMENT_REPO}/*
