npm:
	cd "$(ROOT_DIR)" && xargs -r npm install -g -- < pkgs/npm/packages.list

.PHONY: npm
