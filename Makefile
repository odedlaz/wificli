BIN_DIR=/usr/local/bin
COMPLETEION_DIR=/usr/share/fish/completions
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))


dev: uninstall
	ln -s $(ROOT_DIR)/wlancli $(BIN_DIR)/wlancli
	ln -s $(ROOT_DIR)/completions $(COMPLETEION_DIR)/wlancli.fish

install:
	cp -f ./wlancli $(BIN_DIR)/wlancli
	chown root $(BIN_DIR)/wlancli
	chmod 755 $(BIN_DIR)/wlancli

	cp -f ./completions $(COMPLETEION_DIR)/wlancli.fish
	chown root $(COMPLETEION_DIR)/wlancli.fish

uninstall:
	rm $(BIN_DIR)/wlancli
	rm $(COMPLETEION_DIR)/wlancli.fish

.PHONY: install uninstall
