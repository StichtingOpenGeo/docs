all: setup build

build:
	mdbook build

serve:
	mdbook serve

setup:
	cargo install mdbook --version ~0.4
