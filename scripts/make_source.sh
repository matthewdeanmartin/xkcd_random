#!/usr/bin/env bash
set -euo pipefail
git2md xkcd_random \
  --ignore __pycache__ \
   py.typed  \
  --output SOURCE.md