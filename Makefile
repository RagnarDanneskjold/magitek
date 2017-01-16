.PHONY: vendor

# Vendor ----------------------------------------------------------------------
vendor/quickutils.lisp: vendor/make-quickutils.lisp
	cd vendor && sbcl --noinform --load make-quickutils.lisp  --eval '(quit)'

vendor: vendor/quickutils.lisp


# Build -----------------------------------------------------------------------
lisps := $(shell ffind '\.(asd|lisp|ros)$$')

build/magitek: $(lisps)
	ros build build/magitek.ros

update-deps:
	hg -R /home/sjl/chancery -v pull -u

/opt/antipodes/antipodes: update-deps build/antipodes
	rm -f /opt/antipodes/antipodes
	cp build/antipodes /opt/antipodes/antipodes

deploy: build/magitek
	rsync --exclude=build/magitek --exclude=.hg --exclude=database.sqlite -avz . silt:/home/sjl/magitek
	ssh silt make -C /home/sjl/magitek build/magitek