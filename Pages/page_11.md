# Install LibreLane, OpenROAD, and the ASIC toolchain

Install the complete reproducible open-source ASIC environment. LibreLane bundles compatible versions of Yosys, OpenROAD, Magic, KLayout, Netgen, and the other tools used by the default flow.

## Overview

Do **not** separately install random versions of every EDA tool unless you know exactly why you are doing it.

ASIC flows are sensitive to tool versions.

LibreLane provides a matched environment so:

```text
LibreLane
Yosys
OpenROAD
Magic
KLayout
Netgen
OpenRCX
Volare
```

work together.

There are three common installation methods:

| method | recommendation |
|--------|----------------|
| Nix | best/reproducible |
| AppImage | easiest on Linux/WSL |
| Docker | fallback |

For the network, **Nix is the default path**.

AppImage is a good fallback if Nix gives you trouble.

## Prerequisites

- [RTL-to-GDS overview](page_10.md)
- internet connection
- several GB of free disk space
- Linux/WSL2/macOS

## Steps

### 1. Windows users: install WSL2

Open PowerShell as Administrator:

```powershell
wsl --install -d Ubuntu
```

Restart if Windows asks you to.

Then check:

```powershell
wsl --list --verbose
```

You want Ubuntu to show:

```text
VERSION
2
```

LibreLane requires WSL2, not WSL1.

Launch Ubuntu from the Start menu.

From this point onward, run Linux commands **inside Ubuntu/WSL**, not PowerShell.

### 2. Linux and WSL users: install basic tools

```bash
sudo apt-get update
sudo apt-get install -y curl git
```

### 3. Install Nix

Do **not** install Nix with `apt`.

Use the current Nix installer:

```bash
curl --proto '=https' --tlsv1.2 -fsSL \
  https://artifacts.nixos.org/nix-installer | \
  sh -s -- install --no-confirm --extra-conf "
extra-substituters = https://nix-cache.fossi-foundation.org
extra-trusted-public-keys = nix-cache.fossi-foundation.org:3+K59iFwXqKsL7BNu6Guy0v+uTlwsxYQxjspXzqLYQs=
extra-experimental-features = nix-command flakes
"
```

Close the terminal completely and open it again.

Why the binary cache?

Without it, Nix may build large EDA tools from source.

The cache lets you download reproducible pre-built tool binaries instead.

### 4. Clone LibreLane

```bash
cd ~
git clone https://github.com/librelane/librelane
```

Enter the repository:

```bash
cd ~/librelane
```

### 5. Enter the EDA environment

```bash
nix-shell
```

Your shell prompt should indicate that you are inside a Nix shell.

Every ASIC command in later pages assumes you are inside this environment.

If you leave the shell, enter it again with:

```bash
cd ~/librelane
nix-shell
```

### 6. Run the smoke test

```bash
librelane --smoke-test
```

The first run may also obtain the supported PDK through Volare.

The smoke test must finish successfully before continuing.

### 7. Confirm the important tools exist

Run:

```bash
librelane --version
yosys -V
openroad -version
klayout -v
magic --version
netgen -batch <<<'quit'
```

Exact version strings will change over time.

What matters is that the commands execute inside the LibreLane environment.

### 8. Optional fallback: AppImage

On supported Linux systems:

```bash
sudo apt-get update
sudo apt-get install -y \
  build-essential python3 python3-venv python3-pip \
  python3-tk curl make git
```

Download the matching LibreLane devshell AppImage from the current LibreLane release page.

Most x86-64 machines use:

```text
librelane-devshell-x86_64.AppImage
```

Then:

```bash
chmod a+x ~/librelane-devshell-$(uname -m).AppImage
~/librelane-devshell-$(uname -m).AppImage
```

Test it:

```bash
librelane --smoke-test
```

Do not install both methods just because both exist. Pick one working environment.

### 9. Run the built-in example

Create a scratch folder:

```bash
mkdir -p ~/asic_examples
cd ~/asic_examples
```

Run:

```bash
librelane --run-example spm
```

If the example reaches the end successfully, your machine has completed a real RTL-to-GDS flow.

### 10. Open the example layout

Inside the folder containing the copied example configuration:

```bash
librelane --last-run --flow OpenInKLayout config.json
```

You should see physical chip geometry rather than RTL source code.

## Results

A working installation should provide:

```text
librelane
yosys
openroad
klayout
magic
netgen
```

and a working Sky130 PDK managed by Volare.

Official documentation:

- [LibreLane installation](https://librelane.readthedocs.io/en/stable/installation/)
- [LibreLane newcomer tutorial](https://librelane.readthedocs.io/en/stable/getting_started/newcomers/)
- [OpenROAD documentation](https://openroad.readthedocs.io/)

## Checklist

- [ ] WSL2/Linux/macOS environment works
- [ ] Nix or AppImage environment works
- [ ] `librelane --smoke-test` passes
- [ ] Yosys runs
- [ ] OpenROAD runs
- [ ] KLayout opens
- [ ] Built-in example finishes
- [ ] Opened an example layout
- [ ] Continued to page 12

---

*Questions? Ask in the network Discord.*
