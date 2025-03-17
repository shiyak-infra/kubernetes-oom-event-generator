.PHONY: install clean test image push-image

VERSION := 1.0.0
IMAGE 	:= ghcr.io/shiyak-infra/kubernetes-oom-event-generator
BRANCH 	= $(shell git rev-parse --abbrev-ref HEAD)

all: kubernetes-oom-event-generator

kubernetes-oom-event-generator:
	go build -i

clean:
	go clean ./...

test:
	@go test -v ./...

image:
	docker build -t $(IMAGE):$(VERSION) .

push-image:
	docker push $(IMAGE):$(VERSION)

release: image
ifneq ($(BRANCH),master)
	$(error release only works from master, currently on '$(BRANCH)')
endif
	$(MAKE) perform-release

TAG = $(shell docker run --rm $(IMAGE) --version | grep -oE "kubernetes-oom-event-generator [^ ]+" | cut -d ' ' -f2)

perform-release:
	git tag $(TAG)
	git push origin $(TAG)
	git push origin master
