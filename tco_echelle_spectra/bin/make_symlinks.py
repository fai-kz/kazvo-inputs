#!/usr/bin/env python3
"""
Symlink Generator for TCO Data Collection

Scans chronological directory trees, matches files against a target target list,
and creates symlinks for BOTH the FITS spectra and their corresponding KazVO 
FAIR metadata sidecars (.hdr).
"""

import logging
from pathlib import Path

# ============================================================
# CONFIGURATION BLOCK
# ============================================================

SOURCE_ROOT = "/fai/observations/others/tco/spectra_echelle/targets/"
LIST_FILE = "list_supergiants.txt"
TARGET_DIR = "/var/gavo/inputs/tco_hot_supergiants/data"

# Extensions explicitly recognized as primary data targets
FITS_EXTENSIONS = {".fit", ".fits"}

PRESERVE_STRUCTURE = False
OVERWRITE = False
DRY_RUN = False

# ============================================================
# IMPLEMENTATION
# ============================================================

logging.basicConfig(level=logging.INFO, format="[%(levelname)s] %(message)s")


def normalize_name(name: str) -> str:
    """Extracts the base filename and converts it to lowercase for matching."""
    return Path(name.strip()).name.lower()


def read_wanted_files(list_file: Path) -> set[str]:
    """Parses the target text list file, stripping comments and empty lines."""
    wanted = set()
    with list_file.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            wanted.add(normalize_name(line))
    return wanted


def collect_matching_pairs(source_root: Path, wanted_files: set[str]) -> list[Path]:
    """
    Recursively scans SOURCE_ROOT for matching FITS files.
    If a match is found, both the FITS file and its companion .hdr sidecar
    (if present) are queued for symlinking.
    """
    matched_files = []

    for path in source_root.rglob("*"):
        if not path.is_file():
            continue

        # Step 1: Find the primary FITS file based on your list
        if path.suffix.lower() in FITS_EXTENSIONS and path.name.lower() in wanted_files:
            matched_files.append(path)
            
            # Step 2: Dynamically check for a companion .hdr sidecar file right next to it
            hdr_sidecar = path.with_suffix(path.suffix + ".hdr")
            if hdr_sidecar.exists():
                matched_files.append(hdr_sidecar)

    return sorted(list(set(matched_files)))  # Unique and sorted list


def make_unique_path(path: Path) -> Path:
    """Appends a counter to resolve filename collisions in flat directory structures."""
    if not path.exists() and not path.is_symlink():
        return path

    parent = path.parent
    stem = path.stem
    suffix = path.suffix
    counter = 1

    while True:
        new_path = parent / f"{stem}_{counter}{suffix}"
        if not new_path.exists() and not new_path.is_symlink():
            return new_path
        counter += 1


def create_symlink(source_file: Path, link_path: Path) -> bool:
    """Safely constructs a symlink pointing to the absolute path of the source file."""
    link_path.parent.mkdir(parents=True, exist_ok=True)

    if link_path.exists() or link_path.is_symlink():
        if OVERWRITE:
            if DRY_RUN:
                logging.info(f"[DRY-RUN] Would remove existing link: {link_path}")
            else:
                link_path.unlink()
        else:
            old_name = link_path.name
            link_path = make_unique_path(link_path)
            logging.info(f"Collision detected. Renaming: {old_name} -> {link_path.name}")

    if DRY_RUN:
        logging.info(f"[DRY-RUN] Would link: {link_path} -> {source_file}")
        return False

    link_path.symlink_to(source_file.resolve())
    logging.info(f"[OK] Linked: {link_path.name} -> {source_file}")
    return True


def main() -> None:
    source_root = Path(SOURCE_ROOT).expanduser().resolve()
    list_file = Path(LIST_FILE).expanduser().resolve()
    target_dir = Path(TARGET_DIR).expanduser().resolve()

    if not source_root.is_dir():
        raise NotADirectoryError(f"Invalid source directory: {source_root}")
    if not list_file.exists():
        raise FileNotFoundError(f"Missing target list file: {list_file}")

    target_dir.mkdir(parents=True, exist_ok=True)

    wanted_files = read_wanted_files(list_file)
    matched_files = collect_matching_pairs(source_root, wanted_files)

    # Exclude .hdr extensions when reporting missed targets from the text list
    found_fits_names = {path.name.lower() for path in matched_files if path.suffix.lower() in FITS_EXTENSIONS}
    missing_names = sorted(wanted_files - found_fits_names)

    logging.info(f"Source path: {source_root}")
    logging.info(f"Targets listed: {len(wanted_files)}")
    logging.info(f"Total files queued (Data + Metadata): {len(matched_files)}")
    logging.info(f"Missing primary frames: {len(missing_names)}\n")

    if missing_names:
        logging.warning("The following files from your list were not found:")
        for name in missing_names:
            logging.warning(f"  - {name}")
        print()

    created_count = 0
    for source_file in matched_files:
        if PRESERVE_STRUCTURE:
            relative_path = source_file.relative_to(source_root)
            link_path = target_dir / relative_path
        else:
            link_path = target_dir / source_file.name

        if create_symlink(source_file, link_path):
            created_count += 1

    logging.info(f"Execution complete. Symlinks created: {created_count}")


if __name__ == "__main__":
    main()
