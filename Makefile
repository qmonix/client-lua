BUILD_DIR = build
SRC_DIR = src


all:
	mkdir -p $(BUILD_DIR)/qmonix
	cp -r $(SRC_DIR)/* $(BUILD_DIR)/qmonix
.PHONY: all


clean:
	rm -rf $(BUILD_DIR)
.PHONY: clean
