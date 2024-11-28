# /bin/bash

sudo virt-install \
-n myRHELImageModevm \
--description "RHEL Image mode" \
--os-variant=rhel9.5 \
--ram=5048 \
--vcpus=2 \
--disk path=/var/lib/libvirt/images/myRHEImageModeVMdisk.img,bus=virtio,size=20 \
--graphics vnc \
--cdrom ./output/bootiso/install.iso \
--network bridge:virbr0


