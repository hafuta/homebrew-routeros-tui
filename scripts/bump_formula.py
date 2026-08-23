#!/usr/bin/env python3
"""Rewrite Formula/mikrotik-tui.rb URLs and checksums from the latest GitHub release."""

from __future__ import annotations

import json
import re
import urllib.request
from pathlib import Path

REPO = "hafuta/mikrotik-tui"
FORMULA = Path(__file__).resolve().parent.parent / "Formula" / "mikrotik-tui.rb"
API = f"https://api.github.com/repos/{REPO}/releases/latest"


def fetch_latest() -> tuple[str, dict[str, str]]:
    req = urllib.request.Request(
        API,
        headers={"Accept": "application/vnd.github+json", "User-Agent": "homebrew-mikrotik-tui"},
    )
    with urllib.request.urlopen(req) as resp:
        data = json.load(resp)
    tag = data["tag_name"]
    checksums_url = next(
        a["browser_download_url"] for a in data["assets"] if a["name"] == "checksums.txt"
    )
    with urllib.request.urlopen(
        urllib.request.Request(checksums_url, headers={"User-Agent": "homebrew-mikrotik-tui"})
    ) as resp:
        body = resp.read().decode()
    shas: dict[str, str] = {}
    for line in body.splitlines():
        parts = line.split()
        if len(parts) != 2:
            continue
        digest, name = parts
        shas[name] = digest
    return tag, shas


def main() -> None:
    tag, shas = fetch_latest()
    version = tag.lstrip("v")
    arm = shas["mikrotik-tui-macos-arm64.tar.gz"]
    intel = shas["mikrotik-tui-macos-amd64.tar.gz"]
    text = FORMULA.read_text(encoding="utf-8")
    text = re.sub(
        r"releases/download/v[\d.]+/mikrotik-tui-macos-arm64\.tar\.gz",
        f"releases/download/v{version}/mikrotik-tui-macos-arm64.tar.gz",
        text,
        count=1,
    )
    text = re.sub(
        r"releases/download/v[\d.]+/mikrotik-tui-macos-amd64\.tar\.gz",
        f"releases/download/v{version}/mikrotik-tui-macos-amd64.tar.gz",
        text,
        count=1,
    )
    text = re.sub(
        r'(on_arm do\n\s+url "[^"]+"\n\s+sha256 ")[a-f0-9]+(")',
        rf"\g<1>{arm}\2",
        text,
        count=1,
    )
    text = re.sub(
        r'(on_intel do\n\s+url "[^"]+"\n\s+sha256 ")[a-f0-9]+(")',
        rf"\g<1>{intel}\2",
        text,
        count=1,
    )
    FORMULA.write_text(text, encoding="utf-8")
    print(f"formula -> v{version}")


if __name__ == "__main__":
    main()
