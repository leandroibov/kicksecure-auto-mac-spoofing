## How to Use

### On the `sysmaint` account:
First, install `macchanger`:
```bash
sudo apt update; sudo apt install macchanger
```
Still on the sysmaint account, make the script executable and run it:
```bash
chmod +x kicksecure-mac-spoofing_root.sh
sudo ./kicksecure-mac-spoofing_root.sh
```
Once you log in as a standard user (or any other user), the command sudo macchanger -r eth0 (where eth0 is the default interface on Kicksecure) will be executed automatically to perform MAC spoofing!

Using the user Account with Automatic MAC Spoofing Enabled!
When logging in with the user account, ensure you are disconnected from the internet (no Ethernet cable connected, Wi-Fi off) during the login process.
Monitor the MAC address changes using ip a every 50 seconds...
Once you confirm the MAC address has changed, connect your Ethernet cable or Wi-Fi. The network will then see the spoofed MAC address, while your true hardware MAC remains hidden.

Why this step is critical:
The MAC changing service starts approximately 50 to 120 seconds after the session begins, depending on system performance delays. If you leave the Ethernet cable connected during boot/login, your true original MAC address will be broadcast to the network before the spoofing activates. For maximum security, your real MAC should never appear on the network.

Configurations: Vendor-Specific, Random, or Manual MAC Spooﬁng
After installation, open the configuration file:
```bash
sudo nano /usr/local/bin/mac-spoof-monitor.sh
```
Modify only the following sections based on your desired behavior:

Option 1: Manual Vendor-Specific MAC
To use a specific fake vendor MAC (manually generated):
Generate a fake vendor MAC using a tool like: https://github.com/leandroibov/gerador-de-enderecos-mac
Replace mac-vendor-name with your generated address.
```bash
#/usr/bin/macchanger -r $INTERFACE

#for vendor mac spoofing
#/usr/bin/macchanger -A $INTERFACE

#for manual vendor mac spoofing
/usr/bin/macchanger --mac=mac-vendor-name $INTERFACE
```

Option 2: Random Vendor MACs
To use random MACs from any manufacturer:
You can use either -A (random vendor) or -a (specific vendor pool if supported).
```bash
#/usr/bin/macchanger -r $INTERFACE

#for random vendor mac spoofing
/usr/bin/macchanger -A $INTERFACE

#for manual vendor mac spoofing
#/usr/bin/macchanger --mac=mac-vendor-name $INTERFACE
```

Option 3: Fully Randomized MAC (Default)

`This is the default setting for fully randomized MAC addresses`:
```bash
/usr/bin/macchanger -r $INTERFACE

#for vendor mac spoofing
#/usr/bin/macchanger -A $INTERFACE

#for manual vendor mac spoofing
#/usr/bin/macchanger --mac=mac-vendor-name $INTERFACE
```
# Doe monero para nos ajudar: (donate XMR)
```bash
87JGuuwXzoMGwQAcSD7cvS7D7iacPpN2f5bVqETbUvCgdEmrPZa12gh5DSiKKRgdU7c5n5x1UvZLj8PQ7AAJSso5CQxgjak
```

'Página oficial de segurança digital:'

https://traderprofissional.com.br/seguranca-digital.aspx

