# tc-taps
Simple TC scripts to TAP VM/LXC network interfaces on Linux based hypervisors.

## Usage
These scripts have been tested on Proxmox hypervisors for mirroring traffic into local SecurityOnion instances.

**Steps:**
```
(1) Create a virtual bridge to be used as a SPAN port (e.g., vmbr100).
    - Select Node --> System --> Network --> Create --> Linux Bridge
    - SPAN port should have no IP, gateway, etc.
(2) Add created bridge to a SecurityOnion VM and use that bridge as the SPAN port.
(3) Run the "tc_up" script on the Proxmox host, specifying desired ID range to TAP and pointing to that created bridge.
```
Successful usage should result in SecurityOnion ingesting your desired VM/LXC network traffic.
