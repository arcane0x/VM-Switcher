# kvm to vbox (Linux)

======================

sudo nano /usr/local/bin/vm-switch

-----------------------------------

#!/bin/bash

CPU_VENDOR=$(lscpu | grep Vendor | awk '{print $3}')

enable_kvm() {
    echo "🔁 Switching to KVM mode..."

    sudo modprobe -r vboxdrv vboxnetflt vboxnetadp vboxpci 2>/dev/null

    sudo modprobe kvm
    if [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
        sudo modprobe kvm_intel
    else
        sudo modprobe kvm_amd
    fi

    echo "✅ KVM enabled. Use virt-manager."
}

enable_vbox() {
    echo "🔁 Switching to VirtualBox mode..."

    sudo modprobe -r kvm_intel kvm_amd kvm 2>/dev/null

    sudo modprobe vboxdrv
    sudo modprobe vboxnetflt
    sudo modprobe vboxnetadp
    sudo modprobe vboxpci 2>/dev/null

    echo "✅ VirtualBox enabled."
}

case "$1" in
    kvm)
        enable_kvm
        ;;
    vbox)
        enable_vbox
        ;;
    status)
        echo "🔍 Current virtualization status:"
        lsmod | grep -E "kvm|vbox" || echo "No hypervisor modules loaded"
        ;;
    *)
        echo "Usage:"
        echo "  vm-switch kvm     → Enable KVM"
        echo "  vm-switch vbox   → Enable VirtualBox"
        echo "  vm-switch status → Show active hypervisor"
        ;;
esac

---------------------------------------------------------------------------

sudo chmod +x /usr/local/bin/vm-switch


------------------------------------------END-------------------------------
