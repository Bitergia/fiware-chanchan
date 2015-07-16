.PHONY: help
help:
	$(info )
	$(info This makefile will help you build the docker image for the Fiware-ChanChan application)
	$(info )
	$(info Available options:)
	$(info )
	$(info - all:			Build all available images)
	$(info - chanchanapp:		Build ChanChan App (angular client and flask server))
	$(info )
	@echo ""

.PHONY: chanchanapp
chanchanapp:
	docker build -t bitergia/$@ $@/

.PHONY: all
all: chanchanapp
