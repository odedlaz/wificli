BIN_DIR=/usr/local/bin
COMPLETEION_DIR=/usr/share/fish/completions
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))


dev: uninstall
	ln -s $(ROOT_DIR)/wlancli.fish $(BIN_DIR)/wlancli
	ln -s $(ROOT_DIR)/completions.fish $(COMPLETEION_DIR)/wlancli.fish

install:
	cp -f ./wlancli.fish $(BIN_DIR)/wlancli
	chown root $(BIN_DIR)/wlancli
	chmod 755 $(BIN_DIR)/wlancli

	cp -f ./completions.fish $(COMPLETEION_DIR)/wlancli.fish
	chown root $(COMPLETEION_DIR)/wlancli.fish

uninstall:
	rm -f $(BIN_DIR)/wlancli
	rm -f $(COMPLETEION_DIR)/wlancli.fish

.PHONY: install uninstall
