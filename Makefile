SHARDS=shards
DOCKER=$(shell which docker || which podman)
THREADS=$(shell nproc)

.PHONY: clean build build-static

build:
	$(SHARDS) install --production --release --ignore-crystal-version
	$(SHARDS) build --production --release --progress --threads=$(THREADS)

build-static:
	$(SHARDS) install --production --release --ignore-crystal-version
	$(SHARDS) build --production --release --progress --static --threads=$(THREADS)

build-container:
	$(DOCKER) build -t idleapi:latest .
	$(DOCKER) create --name idleapi idleapi:latest
	$(DOCKER) cp idleapi:/idleapi .

build-container-ci:
	$(DOCKER) build --storage-driver vfs --runtime crun -t idleapi:latest .
	$(DOCKER) create --name idleapi idleapi:latest
	$(DOCKER) cp --pause=false idleapi:/idleapi .

clean:
	rm -rf bin/
	rm -rf lib/
