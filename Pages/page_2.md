# Page 2 — Set up the open-source lab

## What you are learning

On this page you will install the tools used for the first half of ASIC 101 and create the project directory that every later page will use.

## 1. The tools

We will use:

| Tool | Purpose |
| --- | --- |
| Icarus Verilog | Compile and simulate Verilog |
| `vvp` | Execute simulations compiled by Icarus |
| GTKWave | View waveforms |
| Yosys | Synthesize RTL |
| Graphviz | Render Yosys schematics |
| Git | Track your source code |

The easiest way to get the EDA tools together is **OSS CAD Suite**.

OSS CAD Suite includes Yosys, Icarus Verilog, GTKWave, Verilator, formal tools, FPGA tools, and other open-source digital-design software.

## 2. Install OSS CAD Suite

Go to the official release page:

https://github.com/YosysHQ/oss-cad-suite-build/releases/latest

Download the archive matching your operating system.

Typical choices are:

```text
linux-x64
darwin-arm64
windows-x64
```

If you are on Windows and are comfortable with WSL, the OSS CAD Suite maintainers recommend using the Linux build inside WSL for the best experience.

Extract the archive somewhere you will keep it.

For example, on Linux:

```bash
mkdir -p ~/tools
cd ~/tools
```

Extract the downloaded archive so that you eventually have a directory similar to:

```text
~/tools/oss-cad-suite/
```

Activate it:

```bash
source ~/tools/oss-cad-suite/environment
```

You must do this in each new terminal unless you add the command to your shell startup file.

### Optional: activate it automatically

For Bash:

```bash
echo 'source ~/tools/oss-cad-suite/environment' >> ~/.bashrc
source ~/.bashrc
```

If your installation is somewhere else, change the path.

## 3. Install Git

If Git is not already installed, use your operating system's package manager.

Ubuntu/Debian:

```bash
sudo apt update
sudo apt install -y git
```

Git is open-source and will be used to track your progress.

## 4. Verify the EDA tools

Run:

```bash
iverilog -V
vvp -V
yosys -V
gtkwave --version
dot -V
```

Version numbers will change over time.

The important result is:

```text
each command exists and runs
```

If your terminal says:

```text
command not found
```

the OSS CAD Suite environment is probably not active.

Run:

```bash
source ~/tools/oss-cad-suite/environment
```

again.

## 5. Choose a text editor

Use any editor you are comfortable with.

Open-source choices include:

```text
VSCode
VSCodium
Neovim
Vim
Emacs
Kate
```

The editor is not part of the EDA flow. It only edits text files.

## 6. Create the project

Run:

```bash
mkdir -p ~/asic_101
cd ~/asic_101

mkdir -p rtl
mkdir -p sim
mkdir -p scripts
mkdir -p build
mkdir -p reports
mkdir -p screenshots
```

Your project should now look like:

```text
asic_101/
├── rtl/
├── sim/
├── scripts/
├── build/
├── reports/
└── screenshots/
```

The folders have different jobs.

### `rtl/`

Synthesizable hardware source code.

### `sim/`

Testbenches and simulation-only code.

### `scripts/`

Yosys and later EDA scripts.

### `build/`

Generated temporary output.

### `reports/`

Tool reports worth keeping.

### `screenshots/`

Visual evidence from waveforms and layout.

## 7. Initialize Git

Still inside `~/asic_101`:

```bash
git init
```

Create a `.gitignore`:

```bash
cat > .gitignore <<'EOF'
build/
*.vcd
*.fst
*.log
EOF
```

Create a small README:

```bash
cat > README.md <<'EOF'
# ASIC 101

Open-source ASIC 101 project.

Goal: design, verify, synthesize, and physically implement an 8-bit ALU.
EOF
```

Commit the starting point:

```bash
git add .
git commit -m "Start ASIC 101 project"
```

If Git asks you to configure your name or email, follow the commands it prints and repeat the commit.

## 8. Learn four shell commands

You only need a small amount of terminal knowledge to start.

Show the current directory:

```bash
pwd
```

List files:

```bash
ls
```

Change directory:

```bash
cd rtl
```

Go back one directory:

```bash
cd ..
```

That is enough for the next several pages.

## Checkpoint

Run:

```bash
cd ~/asic_101
pwd
ls
iverilog -V
yosys -V
```

You should see your project directory and working tool versions.

## Common problems

### `iverilog: command not found`

Activate OSS CAD Suite again:

```bash
source ~/tools/oss-cad-suite/environment
```

### GTKWave does not open from WSL

On modern Windows systems with WSLg, Linux GUI applications normally work directly.

If your environment does not support Linux GUI applications, you can still complete simulations from the terminal and open waveform files with a waveform viewer available on your host system.

### Spaces in paths

Avoid putting the toolchain or course project in paths with complicated spaces or special characters.

A simple location such as:

```text
~/asic_101
```

avoids many beginner problems.

## Before continuing

Your system is ready when all of these are true:

- [ ] `iverilog -V` works
- [ ] `vvp -V` works
- [ ] `yosys -V` works
- [ ] `gtkwave --version` works
- [ ] `dot -V` works
- [ ] `~/asic_101` exists
- [ ] the project contains `rtl`, `sim`, `scripts`, `build`, `reports`, and `screenshots`
- [ ] Git is initialized

## References

- OSS CAD Suite: https://github.com/YosysHQ/oss-cad-suite-build
- Icarus Verilog: https://steveicarus.github.io/iverilog/
- GTKWave: https://gtkwave.github.io/gtkwave/
- Yosys: https://yosyshq.readthedocs.io/
