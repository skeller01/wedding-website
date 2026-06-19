"""Throwaway static-site deployment scan for the wedding website.

This prototype checks whether local page, script, stylesheet, and image
references resolve when hosted as case-sensitive static files.
"""

from __future__ import annotations

import re
from pathlib import Path
from urllib.parse import urlparse


ROOT = Path(__file__).resolve().parents[4]
HTML_FILES = sorted(ROOT.glob("*.html"))


ATTR_RE = re.compile(r"""(?:href|src|action)\s*=\s*["']([^"']+)["']""", re.I)
CSS_URL_RE = re.compile(r"""url\(["']?([^)"']+)["']?\)""", re.I)
AJAX_URL_RE = re.compile(r"""url\s*:\s*["']([^"']+)["']""", re.I)


def is_external(ref: str) -> bool:
    parsed = urlparse(ref)
    return bool(parsed.scheme in {"http", "https", "mailto", "tel"})


def normalize_local_ref(source: Path, ref: str) -> Path | None:
    clean = ref.split("#", 1)[0].split("?", 1)[0].strip()
    if not clean or clean == "#":
        return None
    if is_external(clean):
        return None
    if clean.startswith("//"):
        return None
    base = source.parent
    return (base / clean).resolve()


def case_sensitive_exists(path: Path) -> bool:
    if not path.exists():
        return False
    try:
        current = path.anchor
        remainder = Path(*path.parts[1:]) if path.anchor else path
        probe = Path(current) if current else Path(".")
        for part in remainder.parts:
            names = {child.name for child in probe.iterdir()}
            if part not in names:
                return False
            probe = probe / part
        return True
    except OSError:
        return path.exists()


def collect_refs(source: Path) -> list[str]:
    text = source.read_text(encoding="utf-8", errors="replace")
    refs = ATTR_RE.findall(text)
    refs.extend(CSS_URL_RE.findall(text))
    refs.extend(AJAX_URL_RE.findall(text))
    return refs


def main() -> None:
    checked = []
    missing = []
    server_runtime = []
    external = set()

    source_files = HTML_FILES + sorted((ROOT / "css").glob("*.css")) + sorted((ROOT / "js").glob("*.js"))

    for source in source_files:
        for ref in collect_refs(source):
            if is_external(ref) or ref.startswith("//"):
                external.add(ref)
                continue
            target = normalize_local_ref(source, ref)
            if target is None:
                continue
            rel_target = target.relative_to(ROOT) if ROOT in target.parents or target == ROOT else target
            rel_source = source.relative_to(ROOT)
            if target.suffix.lower() == ".php":
                server_runtime.append((str(rel_source), ref))
            if case_sensitive_exists(target):
                checked.append((str(rel_source), ref, str(rel_target)))
            else:
                missing.append((str(rel_source), ref, str(rel_target)))

    php_files = sorted(ROOT.glob("**/*.php"))

    print("Static site scan")
    print("================")
    print(f"HTML pages: {len(HTML_FILES)}")
    print(f"Local references resolved: {len(checked)}")
    print(f"Missing or case-mismatched references: {len(missing)}")
    print(f"Server-side runtime references: {len(server_runtime)}")
    print(f"PHP files present: {len(php_files)}")
    print(f"External references: {len(external)}")

    if missing:
        print("\nMissing or case-mismatched references:")
        for source, ref, target in missing:
            print(f"- {source}: {ref} -> {target}")

    if server_runtime:
        print("\nServer-side runtime references:")
        for source, ref in server_runtime:
            print(f"- {source}: {ref}")

    if php_files:
        print("\nPHP files:")
        for php_file in php_files:
            print(f"- {php_file.relative_to(ROOT)}")

    if external:
        print("\nExternal references:")
        for ref in sorted(external):
            print(f"- {ref}")


if __name__ == "__main__":
    main()
