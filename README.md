# DEV ⚡

A lightweight setup for installing development tools and configurations without manual searching. This repository provides automated scripts to install essential development tools with personalized configurations using Iceberg Dark and Nord themes with DejaVu Sans Mono font. Everything installs in under 20 minutes, including dependencies.

## Quick Start

Run the main installation:

```bash
./run
```

Apply your dotfiles configuration:

```bash
./dev-env
```

### Dry Run

Preview changes without making modifications:

```bash
./run --dry
./dev-env --dry
```

## Run Installation Scripts

Scripts are organized into core and optional categories with brief explanations of each tool.

### Core Scripts (`runs/`)

- **docker** - Container runtime with lazydocker TUI for easy management
- **flameshot** - Screenshot tool with i3 integration
- **ghostty** - Modern terminal emulator with GPU acceleration
- **i3** - Tiling window manager with custom keybindings, Iceberg Dark theme, and status bar
- **lazygit** - TUI for Git operations
- **neovim** - Modern Vim fork with LSP support, treesitter syntax highlighting, and plugins for efficient coding
- **rofi** - Application launcher and window switcher with custom themes
- **tmux** - Terminal multiplexer for managing multiple sessions
- **tools** - CLI utilities (fzf fuzzy finder, bat cat clone with syntax highlighting, task runner, zoxide smart cd, fd find replacement)
- **zen-browser** - Firefox-based browser

### Optional Scripts (`runs_optional/`)

- **cuda** - NVIDIA CUDA toolkit for GPU computing
- **cursor** - AI-powered code editor
- **git-lfs** - Git Large File Storage for handling large files
- **lmstudio** - Local LLM interface for running language models
- **mujoco** - Physics simulation engine
- **nvidia** - NVIDIA drivers and CUDA toolkit
- **nvidia-container** - NVIDIA container toolkit for GPU-accelerated containers
- **ollama** - Local LLM runner
- **open-ai-codex** - OpenAI Codex CLI for code completion
- **opencode** - AI coding assistant

Run all core scripts:

```bash
./run
```

Run all optional scripts:

```bash
./run --optional
```

Run specific script:

```bash
./run neovim
```

## Container Tools (`container-tools/`)

Development container management utilities for devcontainers.

The main goal is to enable LSP-enabled development in nvim within devcontainer environments.

### ⚠️ Important

These scripts must be run from within a repository that contains `devcontainer.json` files, as they query the system to discover and interact with devcontainer configurations.

### Available Tools

- **setup** - Interactive nvim devcontainer setup tool with LSP configurations
  - Automatically discovers devcontainer configurations
  - Interactive configuration selection
  - Consistent nvim config mounting
  - Dry run mode for safe testing

- **access** - Simple devcontainer access script
  - Bash into selected devcontainers
  - Automatic container user detection
  - Interactive configuration selection

- **cleanup** - Clean up specific devcontainers
  - Targeted cleanup for selected devcontainer configurations
  - Based on devcontainer.json files
  - Safe container removal

### Usage

```bash
# Setup nvim in devcontainer
./container-tools/setup

# Access devcontainer
./container-tools/access

# Clean up devcontainer
./container-tools/cleanup

# Preview setup without execution
./container-tools/setup --dry
```

## Configuration

The `./dev-env` script copies dotfiles to your home directory, replacing existing configurations.

### ⚠️ Warning

`dev-env` will **delete** your current configuration and is **not recoverable**. Always test with `--dry` first.

### Customization

- Edit files in `dotfiles/` to personalize
- Run `./dev-env` again to apply changes
- Use `--dry` to preview what will be changed

## 🌟 Interesting Tools

### Git Worktrees

**Documentation:** [Git worktree manual](https://git-scm.com/docs/git-worktree)

Work on multiple branches simultaneously in separate directories.

```bash
# Setup bare repo (recommended)
git clone --bare <url> project.git
cd project.git

# Add worktrees
git worktree add ../main main
git worktree add ../feature -b feature-branch

# Manage worktrees
git worktree list
git worktree remove ../feature
```

### Git Log

**Documentation:** [Git log manual](https://git-scm.com/docs/git-log)

Search commit history and view changes.

```bash
# One line format
git log --oneline

# Search commits that added/removed specific text
git log -S "searched_text"

```

### Unix Tools Quick Reference

| Tool                                                | Best For                     | Input Type      |
| --------------------------------------------------- | ---------------------------- | --------------- |
| **[awk](#awk---text-processing-tool)**              | Column data processing       | Structured text |
| **[grep](#grep---global-regular-expression-print)** | Searching patterns           | Any text        |
| **[jq](#jq---json-processor)**                      | JSON manipulation            | JSON only       |
| **[parallel](#parallel---parallel-execution)**      | CPU-intensive parallel tasks | Command lists   |
| **[sed](#sed---stream-editor)**                     | Simple find/replace          | Text streams    |
| **[xargs](#xargs---execute-arguments)**             | Converting input to args     | Command lists   |

---

### awk - Text Processing Tool

**Documentation:** [GNU awk manual](https://www.gnu.org/software/gawk/manual/gawk.html)

**What it does:** Process structured text, perform calculations on columns

**Pros:** Great for column-based data, built-in math functions  
**Cons:** Learning curve for complex operations

**Examples:**

```bash
# Print specific columns
ps aux | awk '{print $1, $11}'

# Sum memory usage (column 6) for all processes
ps aux | grep -v PID | awk '{sum += $6} END {print "Total:", sum}'

# Print lines where column 3 > 50
awk '$3 > 50' data.txt

# Calculate average of column 2
awk '{sum += $2; count++} END {print sum/count}' numbers.txt
```

---

### grep - Global Regular Expression Print

**Documentation:** [GNU grep manual](https://www.gnu.org/software/grep/manual/grep.html)

**What it does:** Search for patterns in text

**Pros:** Fast, simple syntax, everywhere  
**Cons:** Limited to searching (no replacing)

**Examples:**

```bash
# Basic search
grep "pattern" file.txt

# Case insensitive
grep -i "pattern" file.txt

# Show line numbers
grep -n "pattern" file.txt

# Recursive search in directories
grep -r "pattern" /path/to/dir

# Invert match (show lines that DON'T contain pattern)
grep -v "pattern" file.txt
```

---

### jq - JSON Processor

**Documentation:** [jq manual](https://jqlang.github.io/jq/manual/)

**What it does:** Parse, filter, and manipulate JSON data

**Pros:** Powerful JSON handling, readable output  
**Cons:** JSON-only, complex syntax for advanced operations

**Examples:**

```bash
# Pretty print JSON
curl api.example.com | jq '.'

# Extract specific field
echo '{"name": "John", "age": 30}' | jq '.name'

# Filter arrays
echo '[{"name": "John"}, {"name": "Jane"}]' | jq '.[].name'

# Select objects with condition
jq '.[] | select(.age > 25)' people.json
```

---

### parallel - Parallel Execution

**Documentation:** [GNU parallel manual](https://www.gnu.org/software/parallel/parallel.html)

**What it does:** Run jobs in parallel across multiple cores

**Pros:** True parallelism, great for CPU-intensive tasks, keeps output order with `-k`  
**Cons:** Additional installation required, more complex than xargs

**Key flags:** `-k` (keep order), `-j` (number of jobs)

**Examples:**

```bash
# Process files in parallel, keep output order
ls *.jpg | parallel -kj 4 convert {} {.}.png

# Parallel downloads
echo -e "url1\nurl2\nurl3" | parallel -j 3 wget {}

# Run command on multiple servers
parallel -kj 2 ssh {} 'uptime' ::: server1 server2 server3

# Process with multiple arguments
parallel -kj 4 echo "Processing {1} with {2}" ::: file1 file2 ::: option1 option2
```

---

### sed - Stream Editor

**Documentation:** [GNU sed manual](https://www.gnu.org/software/sed/manual/sed.html)

**What it does:** Find and replace text in files or streams

**Pros:** Fast, powerful regex support, works with pipes
**Cons:** Complex syntax, hard to debug

**Pro tip:** Use vim to test your search pattern first: `:/pattern/` to highlight matches

**Examples:**

```bash
# Replace first occurrence per line
sed 's/old/new/' file.txt

# Replace all occurrences
sed 's/old/new/g' file.txt

# Edit file in place
sed -i 's/old/new/g' file.txt

# Delete lines containing pattern
sed '/pattern/d' file.txt
```

---

### xargs - Execute Arguments

**Documentation:** [xargs manual](https://man7.org/linux/man-pages/man1/xargs.1.html)

**What it does:** Convert input into arguments for other commands

**Pros:** Handles spaces/special characters, parallel execution
**Cons:** Can be tricky with filenames containing spaces

**Examples:**

```bash
# Delete files found by find
find . -name "*.tmp" | xargs rm

# Handle filenames with spaces safely
find . -name "*.txt" -print0 | xargs -0 wc -l

# Run command for each line
echo -e "file1\nfile2\nfile3" | xargs -I {} cp {} backup/

# Parallel execution (4 jobs)
echo -e "1\n2\n3\n4" | xargs -P 4 -I {} sleep {}
```

---

### parallel - Parallel Execution

**Documentation:** [GNU parallel manual](https://www.gnu.org/software/parallel/parallel.html)

**What it does:** Run jobs in parallel across multiple cores

**Pros:** True parallelism, great for CPU-intensive tasks, keeps output order with `-k`
**Cons:** Additional installation required, more complex than xargs

**Key flags:** `-k` (keep order), `-j` (number of jobs)

**Examples:**

```bash
# Process files in parallel, keep output order
ls *.jpg | parallel -kj 4 convert {} {.}.png

# Parallel downloads
echo -e "url1\nurl2\nurl3" | parallel -j 3 wget {}

# Run command on multiple servers
parallel -kj 2 ssh {} 'uptime' ::: server1 server2 server3

# Process with multiple arguments
parallel -kj 4 echo "Processing {1} with {2}" ::: file1 file2 ::: option1 option2
```

### Pro Tips

- **Chain tools:** `ps aux | grep firefox | awk '{print $2}' | xargs kill`
- **Test first:** Use `echo` or `--dry-run` flags when possible
- **Read the man pages:** `man command` for detailed help
