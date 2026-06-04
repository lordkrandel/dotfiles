#!/bin/env python3

import sys
import subprocess
from pathlib import Path

# Use provided path or current directory
start_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()

try:
    # Run git to get the repo root directory
    result = subprocess.run(
        ["git", "-C", str(start_path), "rev-parse", "--show-toplevel"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=True,
        text=True
    )
    repo_root = result.stdout.strip()
    print(repo_root)
except subprocess.CalledProcessError:
    sys.exit(1)
