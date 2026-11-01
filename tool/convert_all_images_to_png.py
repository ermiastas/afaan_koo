from __future__ import annotations

import argparse
import csv
import sys
from pathlib import Path

from PIL import Image, UnidentifiedImageError

ROOT = Path(__file__).resolve().parent.parent
SOURCE_DIR = ROOT / "assets"
STAGING_DIR = ROOT / "build" / "png_conversion_staging"
REPORT_FILE = ROOT / "build" / "image_conversion_report.csv"

IMAGE_EXTENSIONS = {
    ".png", ".jpg", ".jpeg", ".webp", ".bmp", ".gif",
    ".tif", ".tiff", ".jfif", ".ico", ".avif", ".heic",
}


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Inspect image contents and safely stage verified PNG files."
    )
    parser.add_argument(
        "--convert",
        action="store_true",
        help="Write verified PNGs to a separate staging directory.",
    )
    args = parser.parse_args()

    if not SOURCE_DIR.is_dir():
        print(f"ERROR: Assets directory not found: {SOURCE_DIR}")
        return 1

    files = sorted(p for p in SOURCE_DIR.rglob("*") if p.is_file())
    REPORT_FILE.parent.mkdir(parents=True, exist_ok=True)

    rows = []
    counts = {
        "PNG_READY": 0,
        "PNG_STAGED": 0,
        "SKIPPED_NON_IMAGE": 0,
        "SKIPPED_ANIMATED": 0,
        "FAILED": 0,
    }
    reserved: set[Path] = set()

    print("Mode:", "CONVERT TO STAGING" if args.convert else "DRY RUN")
    print("Scanning every file; extensions are not trusted.")
    print(f"Files to inspect: {len(files)}")

    for source in files:
        relative = source.relative_to(SOURCE_DIR)
        row = {
            "source": relative.as_posix(),
            "extension": source.suffix.lower(),
            "actual_format": "",
            "width": "",
            "height": "",
            "frames": "",
            "status": "",
            "staged_output": "",
            "message": "",
        }

        try:
            with Image.open(source) as image:
                actual_format = (image.format or "UNKNOWN").upper()
                row["actual_format"] = actual_format
                row["width"] = image.width
                row["height"] = image.height
                frames = getattr(image, "n_frames", 1)
                row["frames"] = frames

                if getattr(image, "is_animated", False) and frames > 1:
                    row["status"] = "SKIPPED_ANIMATED"
                    row["message"] = (
                        "Animation preserved in original; conversion skipped."
                    )
                    counts["SKIPPED_ANIMATED"] += 1
                    rows.append(row)
                    print(f"[ANIMATED - SKIP] {relative}")
                    continue

                image.load()

                # Keep output outside assets so Flutter and pack builds
                # cannot accidentally consume staged files.
                output_relative = relative.with_suffix(".png")
                output = STAGING_DIR / output_relative

                # Avoid collisions, e.g. icon.jpg and icon.png.
                if output in reserved or output.exists():
                    output = output.with_name(
                        f"{output.stem}__from_{source.suffix.lower().lstrip('.')}.png"
                    )
                    serial = 2
                    while output in reserved or output.exists():
                        output = output.with_name(
                            f"{output.stem.rsplit('__', 1)[0]}__{serial}.png"
                        )
                        serial += 1

                reserved.add(output)
                row["staged_output"] = output.relative_to(ROOT).as_posix()

                if not args.convert:
                    row["status"] = "PNG_READY"
                    row["message"] = (
                        "Image decoded successfully; no files written."
                    )
                    counts["PNG_READY"] += 1
                    print(
                        f"[IMAGE] {relative} | actual={actual_format} "
                        f"| extension={source.suffix.lower() or '(none)'}"
                    )
                    rows.append(row)
                    continue

                output.parent.mkdir(parents=True, exist_ok=True)

                # Preserve alpha and transparency where present.
                has_alpha = (
                    "A" in image.getbands()
                    or "transparency" in image.info
                )
                converted = image.convert("RGBA" if has_alpha else "RGB")
                converted.save(output, format="PNG", optimize=True)

                # Verify the actual output bytes and decode the output.
                with Image.open(output) as check:
                    if check.format != "PNG":
                        raise ValueError("Output is not a real PNG.")
                    check.load()

                row["status"] = "PNG_STAGED"
                row["message"] = "PNG created and verified; original untouched."
                counts["PNG_STAGED"] += 1
                print(f"[STAGED] {relative} -> {row['staged_output']}")

        except (UnidentifiedImageError, OSError, ValueError) as exc:
            # A non-image file is expected in assets (audio, JSON, fonts, etc.).
            # Record files with image-like extensions as failures, not silently
            # ignore them; other unrecognized files are reported as non-images.
            if source.suffix.lower() in IMAGE_EXTENSIONS:
                row["status"] = "FAILED"
                row["message"] = f"{type(exc).__name__}: {exc}"
                counts["FAILED"] += 1
                print(f"[IMAGE ERROR] {relative}: {exc}")
            else:
                row["status"] = "SKIPPED_NON_IMAGE"
                row["message"] = "Not a readable image; left untouched."
                counts["SKIPPED_NON_IMAGE"] += 1

        except Exception as exc:
            row["status"] = "FAILED"
            row["message"] = f"{type(exc).__name__}: {exc}"
            counts["FAILED"] += 1
            print(f"[FAILED] {relative}: {exc}")

        rows.append(row)

    with REPORT_FILE.open("w", newline="", encoding="utf-8-sig") as report:
        writer = csv.DictWriter(report, fieldnames=list(rows[0].keys()) if rows else [
            "source", "extension", "actual_format", "width", "height",
            "frames", "status", "staged_output", "message",
        ])
        writer.writeheader()
        writer.writerows(rows)

    print("\n===== SUMMARY =====")
    print(f"Files inspected: {len(files)}")
    for status, count in counts.items():
        print(f"{status}: {count}")
    print(f"Report: {REPORT_FILE}")

    if args.convert:
        print(f"Staging folder: {STAGING_DIR}")
        print("Original assets were not changed or deleted.")
    else:
        print("Dry run only; no images were converted.")

    return 1 if counts["FAILED"] else 0


if __name__ == "__main__":
    sys.exit(main())
