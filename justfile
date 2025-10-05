[parallel]
dev:
    overmind start -f Procfile.dev

[parallel]
test-all:
    just server/test
    just client/test

[parallel]
build-all:
    just server/build
    just client/build
