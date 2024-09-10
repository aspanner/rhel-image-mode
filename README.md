#1 Build your RHEL image for image mode:
` sudo podman build --creds username:password  -f Containerfile -t quay.io/youruser/yourcontainerimage:yourtag`

then get your image id with `sudo podman images` and then push your freshly build image to quay.io via `sudo podman push <imageID> quay.io/youruser/yourcontainerimage:yourtag`


Now you are ready to run the bootc image builder and reference aforementioned image:

```
sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    -v $(pwd)/config.toml:/config.toml \
    -v $(pwd)/output:/output \
    registry.redhat.io/rhel9/bootc-image-builder:latest \
    --type iso \
    --config config.toml \
  quay.io/<youruser>/<yourcontainerimage>:<yourtag>
```
