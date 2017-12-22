BIN_DIR=/usr/local/bin
COMPLETEION_DIR=/usr/share/fish/completions
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))


dev: uninstall
	ln -s $(ROOT_DIR)/wificli.fish $(BIN_DIR)/wificli
	ln -s $(ROOT_DIR)/completions.fish $(COMPLETEION_DIR)/wificli.fish

install:
	cp -f ./wificli.fish $(BIN_DIR)/wificli
	chown root $(BIN_DIR)/wificli
	chmod 755 $(BIN_DIR)/wificli

	cp -f ./completions.fish $(COMPLETEION_DIR)/wificli.fish
	chown root $(COMPLETEION_DIR)/wificli.fish

uninstall:
	rm -f $(BIN_DIR)/wificli
	rm -f $(COMPLETEION_DIR)/wificli.fish

.PHONY: install uninstall
