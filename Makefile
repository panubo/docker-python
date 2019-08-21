SUBDIRS := 2.7 3.2 3.3 3.4 3.5 3.6 3.7 all

.PHONY: build push clean

build:
	for dir in $(SUBDIRS); do \
		make TAG=$$dir -C $$dir $(MAKECMDGOALS); \
  done

push:
	for dir in $(SUBDIRS); do \
		make TAG=$$dir -C $$dir $(MAKECMDGOALS); \
	done

clean:
	for dir in $(SUBDIRS); do \
		make TAG=$$dir -C $$dir $(MAKECMDGOALS); \
	done
