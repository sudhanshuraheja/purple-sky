create:
	hugo new site . --force

dev:
	hugo server -D

build:
	hugo -D

caddy: build
	caddy run