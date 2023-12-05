IMAGE_NAME="snapshot-explorer"
SE="snapshot-explorer"

run:
	docker run -it \
	    --network=host \
	    --env DISPLAY=127.0.0.1:11.0 \
	    --privileged \
	    --volume="$${HOME}/.Xauthority:$${HOME}/.Xauthority:rw" \
	    --volume="/tmp/.X11-unix:/tmp/.X11-unix" \
	    --env DBUS_SESSION_BUS_ADDRESS="$${DBUS_SESSION_BUS_ADDRESS}" \
	    --volume /run/user/1000/bus:/run/user/1000/bus \
	    --user $$(id -u):$$(id -g) \
	    --volume /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
	    --volume /home/niziak:/home/niziak \
	    --rm $(IMAGE_NAME)
build:
	docker build . -t $(IMAGE_NAME)

install:
	sudo apt-get install libgtk-3-0 libhandy-1-0 zfsutils-linux
	docker run --rm --entrypoint cat $(IMAGE_NAME) /usr/local/bin/snapshot-explorer > ./snapshot-explorer
	chmod +x ./$(SE)
	sudo cp ./$(SE) /usr/local/bin
