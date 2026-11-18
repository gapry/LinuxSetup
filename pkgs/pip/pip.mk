pip:
	cd "$(ROOT_DIR)" && xargs -r -I '{}' pipx install '{}' < pkgs/pip/packages.list

.PHONY: pip
