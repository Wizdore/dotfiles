set -e

if [ -z "$__DEVBOX_SKIP_INIT_HOOK_5c640d69bc97b578eecaa31871e70ac1c964099fde44772a2ad3c4bbabe5d123" ]; then
    . "/home/wizdore/Scripts/BusTimes/.devbox/gen/scripts/.hooks.sh"
fi

go build -ldflags="-w -s -extldflags '-static' -buildid=" -tags "netgo osusergo static_build" -trimpath -gcflags=all="-l -B" -o BusTimes hello.go
