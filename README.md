#1 Build your RHEL image for image mode:
The RHSM (Red Hat Subscription Manager) user is  your Red Hat user and the password is injected via the rhsm_password file so that it's not showing up in your bash history.
`sudo podman build --creds YOUR_RHSM_USER:YourPWD   -f Containerfile -t quay.io/youruser/yourcontainerimage:yourtag --build-arg RHSM_USER=YOUR_RHSM_USER --secret=id=rhsm_password,src=./rhsm_password`

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

#2 Create your kvm based virtual machine based on the iso you create above and run it via the createVM.sh script.
