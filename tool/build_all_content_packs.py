from __future__ import annotations

import hashlib
import json
import shutil
import struct
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE_ROOT = ROOT / "lib" / "content"
PHASE2_SOURCE_ROOT = ROOT / "build" / "lesson_export_phase2"

# All outputs go into a NEW directory. Existing pack builds are preserved.
OUTPUT_ROOT = ROOT / "build" / "content_packs_phase2"

PACKS = [
    {
        "id": "alphabet",
        "source": "alphabet/letters.json",
        "output": "alphabet.json",
        "name": "Qubee Afaan Oromoo",
        "category": "alphabet",
        "version": 2,
    },
    {
        "id": "animals_v2",
        "source": "animals/animals.json",
        "output": "animals.json",
        "name": "Uumama - Bineensota",
        "category": "animals",
        "version": 3,
    },
    {
        "id": "colors",
        "source": "colors/colors.json",
        "output": "colors.json",
        "name": "Halluuwwan",
        "category": "colors",
        "version": 1,
    },
    {
        "id": "numbers",
        "source": "numbers/numbers.json",
        "output": "numbers.json",
        "name": "Lakkoofsota",
        "category": "numbers",
        "version": 2,
    },
    {
        "id": "quizzes",
        "source": "quizzes/quizzes.json",
        "output": "quizzes.json",
        "name": "Gaaffii fi Deebii",
        "category": "quizzes",
        "version": 1,
    },
    {
        "id": "songs",
        "source": "songs/songs.json",
        "output": "songs.json",
        "name": "Sirboota",
        "category": "songs",
        "version": 1,
    },
    {
        "id": "stories",
        "source": "stories/stories.json",
        "output": "stories.json",
        "name": "Seenaa Daa'immanii",
        "category": "stories",
        "version": 1,
    },
    {
        "id": "words",
        "source": "words/words.json",
        "output": "words.json",
        "name": "Jechoota Afaan Oromoo",
        "category": "words",
        "version": 2,
    },
    {
        "id": "math", "source": "math.json", "output": "math.json",
        "name": "Herrega", "category": "math", "version": 1, "source_root": "phase2",
    },
    {
        "id": "time_math", "source": "time_math.json", "output": "time_math.json",
        "name": "Herrega Yeroo", "category": "math", "version": 1, "source_root": "phase2",
    },
    {
        "id": "plants", "source": "plants.json", "output": "plants.json",
        "name": "Biqiltoota", "category": "nature", "version": 1, "source_root": "phase2",
    },
    {
        "id": "weather", "source": "weather.json", "output": "weather.json",
        "name": "Haala Qilleensaa", "category": "nature", "version": 1, "source_root": "phase2",
    },
    {
        "id": "fruits", "source": "fruits.json", "output": "fruits.json",
        "name": "Fuduraalee", "category": "food", "version": 1, "source_root": "phase2",
    },
    {
        "id": "vegetables", "source": "vegetables.json", "output": "vegetables.json",
        "name": "Kuduraalee", "category": "food", "version": 1, "source_root": "phase2",
    },
    {
        "id": "home_objects", "source": "home_objects.json", "output": "home_objects.json",
        "name": "Meeshaalee Manaa", "category": "daily_life", "version": 1, "source_root": "phase2",
    },
    {
        "id": "coloring", "source": "coloring.json", "output": "coloring.json",
        "name": "Halluu Dibuu", "category": "creative", "version": 1, "source_root": "phase2",
    },
    {
        "id": "market", "source": "market.json", "output": "market.json",
        "name": "Gabaa", "category": "daily_life", "version": 1, "source_root": "phase2",
    },
    {
        "id": "money", "source": "money.json", "output": "money.json",
        "name": "Maallaqa", "category": "math", "version": 1, "source_root": "phase2",
    },
    {
        "id": "time", "source": "time.json", "output": "time.json",
        "name": "Yeroo", "category": "daily_life", "version": 1, "source_root": "phase2",
    },
    {
        "id": "month", "source": "month.json", "output": "month.json",
        "name": "Ji'oota", "category": "time", "version": 1, "source_root": "phase2",
    },
    {
        "id": "occupation", "source": "occupation.json", "output": "occupation.json",
        "name": "Ogummaa", "category": "community", "version": 1, "source_root": "phase2",
    },
    {
        "id": "transport", "source": "transport.json", "output": "transport.json",
        "name": "Geejjiba", "category": "community", "version": 1, "source_root": "phase2",
    },
    {
        "id": "hygiene", "source": "hygiene.json", "output": "hygiene.json",
        "name": "Qulqullina", "category": "health", "version": 1, "source_root": "phase2",
    },
    {
        "id": "traffic", "source": "traffic.json", "output": "traffic.json",
        "name": "Tiraafikaa", "category": "safety", "version": 1, "source_root": "phase2",
    },
    {
        "id": "oromo_culture", "source": "oromo_culture.json", "output": "oromo_culture.json",
        "name": "Aadaa Oromoo", "category": "culture", "version": 1, "source_root": "phase2",
    },
    {
        "id": "hibboo", "source": "hibboo.json", "output": "hibboo.json",
        "name": "Hibboo", "category": "games", "version": 1, "source_root": "phase2",
    },
    {
        "id": "mammaaksa", "source": "mammaaksa.json", "output": "mammaaksa.json",
        "name": "Mammaaksa", "category": "culture", "version": 1, "source_root": "phase2",
    },
    {
        "id": "school", "source": "school.json", "output": "school.json",
        "name": "Mana Barumsaa", "category": "education", "version": 1, "source_root": "phase2",
    },
    {
        "id": "school_supplies", "source": "school_supplies.json", "output": "school_supplies.json",
        "name": "Meeshaalee Barnootaa", "category": "education", "version": 1, "source_root": "phase2",
    },
    {
        "id": "shape", "source": "shape.json", "output": "shape.json",
        "name": "Boca", "category": "math", "version": 1, "source_root": "phase2",
    },
    {
        "id": "multiplication_game", "source": "multiplication_game.json", "output": "multiplication_game.json",
        "name": "Tapha Baay'isuu", "category": "games", "version": 1, "source_root": "phase2",
    },
    {
        "id": "division_game", "source": "division_game.json", "output": "division_game.json",
        "name": "Tapha Hiruu", "category": "games", "version": 1, "source_root": "phase2",
    },
    {
        "id": "handwriting", "source": "handwriting.json", "output": "handwriting.json",
        "name": "Barreessuu", "category": "literacy", "version": 1, "source_root": "phase2",
    },
]

MIN_APP_VERSION = "1.0.0"
LANGUAGE = "om"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_content_checksum(pack_dir: Path) -> str:
    """Must match ContentPackArchiveValidator's checksum algorithm."""
    entries = []

    for path in pack_dir.rglob("*"):
        if not path.is_file():
            continue

        relative = path.relative_to(pack_dir).as_posix()

        if relative == "manifest.json":
            continue

        entries.append((relative, path.read_bytes()))

    entries.sort(key=lambda item: item[0])
    payload = bytearray()

    for relative, content in entries:
        path_bytes = relative.encode("utf-8")
        payload.extend(struct.pack(">Q", len(path_bytes)))
        payload.extend(path_bytes)
        payload.extend(struct.pack(">Q", len(content)))
        payload.extend(content)

    return sha256(bytes(payload))


def resolve_asset(raw_value: object, field: str) -> Path | None:
    if not isinstance(raw_value, str) or not raw_value.strip():
        return None

    raw = raw_value.strip().replace("\\", "/")

    # Do not copy remote URLs or data URLs as local files.
    if raw.startswith(("http://", "https://", "data:")):
        return None

    relative = Path(raw)
    candidates = [
        ROOT / relative,
        ROOT / "assets" / relative,
    ]

    filename = Path(raw).name

    if field in ("sound", "word_sound"):
        candidates.extend([
            ROOT / "assets" / "audio" / filename,
            ROOT / "assets" / "assets" / filename,
        ])
    elif field == "image":
        candidates.extend([
            ROOT / "assets" / "images" / filename,
            ROOT / "assets" / "assets" / "images" / filename,
        ])

    for candidate in candidates:
        if candidate.is_file():
            return candidate.resolve()

    # Basename fallback is accepted only when unique.
    # This avoids silently selecting the wrong file with a duplicate name.
    search_roots = [
        ROOT / "assets",
        ROOT / "lib" / "content",
    ]
    matches = []

    for search_root in search_roots:
        if search_root.is_dir():
            matches.extend(
                p.resolve()
                for p in search_root.rglob(filename)
                if p.is_file()
            )

    unique_matches = sorted(set(matches))

    if len(unique_matches) == 1:
        return unique_matches[0]

    return None


def copy_asset(
    source: Path,
    pack_dir: Path,
    media_kind: str,
    copied_assets: dict[str, str],
) -> str:
    # Reuse an asset already copied into this pack.
    source_key = source.as_posix()
    if source_key in copied_assets:
        return copied_assets[source_key]

    filename = source.name

    # Determine the actual image format from its file signature.
    # Do not trust the source extension: some source images are WebP
    # or JPEG files incorrectly named .png.
    if media_kind == "images":
        with source.open("rb") as image_file:
            header = image_file.read(12)

        if header.startswith(bytes.fromhex("89504e470d0a1a0a")):
            extension = ".png"
        elif header.startswith(bytes.fromhex("ffd8ff")):
            extension = ".jpg"
        elif header[:4] == b"RIFF" and header[8:12] == b"WEBP":
            extension = ".webp"
        else:
            raise ValueError(
                f"Unsupported or invalid image format: {source}"
            )

        filename = Path(filename).stem + extension

    digest = hashlib.sha256(source_key.encode("utf-8")).hexdigest()[:10]
    destination_relative = Path("media") / media_kind / f"{digest}_{filename}"
    destination = pack_dir / destination_relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination)

    result = destination_relative.as_posix()
    copied_assets[source_key] = result
    return result
def process_record(
    record: object,
    pack_dir: Path,
    pack_id: str,
    missing_assets: list[dict],
    copied_assets: dict[str, str],
    record_number: int,
) -> object:
    if not isinstance(record, dict):
        return record

    updated = dict(record)

    for field in ("image", "sound", "word_sound"):
        # Handwriting sound is a character identifier, not an audio file.
        if pack_id == "handwriting" and field == "sound":
            continue
        value = updated.get(field)

        if not isinstance(value, str) or not value.strip():
            continue

        source = resolve_asset(value, field)

        if source is None:
            missing_assets.append({
                "pack_id": pack_id,
                "record": record_number,
                "field": field,
                "original_path": value,
                "status": "MISSING_OR_AMBIGUOUS",
            })
            # Avoid packaging a broken local asset reference.
            updated[field] = None
            continue

        kind = "audio" if field in ("sound", "word_sound") else "images"
        updated[field] = copy_asset(
            source, pack_dir, kind, copied_assets
        )

    return updated


def build_pack(config: dict) -> dict:
    source_root = PHASE2_SOURCE_ROOT if config.get("source_root") == "phase2" else SOURCE_ROOT
    source_file = source_root / config["source"]

    if not source_file.is_file():
        raise FileNotFoundError(f"Source JSON not found: {source_file}")

    data = json.loads(source_file.read_text(encoding="utf-8"))

    if not isinstance(data, list):
        raise ValueError(
            f"Expected a JSON list in {source_file}; "
            f"got {type(data).__name__}"
        )

    # Use a dedicated per-pack output directory.
    pack_id = config["id"]
    pack_dir = OUTPUT_ROOT / pack_id / "pack"

    # This script never deletes or replaces existing output directories.
    if pack_dir.exists():
        raise FileExistsError(
            f"Output already exists; nothing was overwritten: {pack_dir}\n"
            "Move/rename that batch output manually before rebuilding."
        )

    lessons_dir = pack_dir / "lessons"
    lessons_dir.mkdir(parents=True, exist_ok=False)

    missing_assets = []
    copied_assets = {}
    updated_records = []

    for index, record in enumerate(data, start=1):
        updated_records.append(
            process_record(
                record=record,
                pack_dir=pack_dir,
                pack_id=pack_id,
                missing_assets=missing_assets,
                copied_assets=copied_assets,
                record_number=index,
            )
        )

    lesson_file = lessons_dir / config["output"]
    lesson_file.write_text(
        json.dumps(
            updated_records,
            ensure_ascii=False,
            indent=2,
        ) + "\n",
        encoding="utf-8",
    )

    content_checksum = canonical_content_checksum(pack_dir)

    # size_bytes in the manifest is the sum of packaged files
    # before manifest.json is written, matching the existing builders.
    content_size = sum(
        p.stat().st_size
        for p in pack_dir.rglob("*")
        if p.is_file()
    )

    manifest = {
        "id": pack_id,
        "name": config["name"],
        "version": config["version"],
        "min_app_version": MIN_APP_VERSION,
        "lesson_count": len(updated_records),
        "size_bytes": content_size,
        "language": LANGUAGE,
        "checksum": content_checksum,
        "is_active": True,
    }

    (pack_dir / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    # ZIP contents are rooted directly at manifest.json and lessons/.
    zip_path = OUTPUT_ROOT / pack_id / f"{pack_id}.zip"
    zip_path.parent.mkdir(parents=True, exist_ok=True)

    with zipfile.ZipFile(
        zip_path,
        mode="x",
        compression=zipfile.ZIP_DEFLATED,
        compresslevel=9,
    ) as archive:
        for path in sorted(pack_dir.rglob("*")):
            if path.is_file():
                archive.write(
                    path,
                    arcname=path.relative_to(pack_dir).as_posix(),
                )

    zip_bytes = zip_path.read_bytes()

    report = {
        "pack_id": pack_id,
        "slug": pack_id,
        "title": config["name"],
        "category": config["category"],
        "version": config["version"],
        "language": LANGUAGE,
        "min_app_version": MIN_APP_VERSION,
        "lesson_count": len(updated_records),
        "size_bytes": len(zip_bytes),
        "content_checksum_sha256": content_checksum,
        "zip_checksum_sha256": sha256(zip_bytes),
        "zip": str(zip_path.resolve()),
        "missing_asset_count": len(missing_assets),
        "copied_asset_count": len(copied_assets),
        "missing_assets": missing_assets,
        "catalog_download_url": (
            f"{pack_id}/{pack_id}.zip"
        ),
        "access_tier": "free",
        "item_type": "lesson",
        "item_id": pack_id,
    }

    report_path = OUTPUT_ROOT / pack_id / "build_report.json"
    report_path.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    return report


def main() -> None:
    OUTPUT_ROOT.mkdir(parents=True, exist_ok=True)

    reports = []
    errors = []

    print(f"Project root: {ROOT}")
    print(f"Batch output: {OUTPUT_ROOT}")
    print("Existing pack build directories will not be deleted.\n")

    for config in PACKS:
        print(f"Building {config['id']} ...")
        try:
            report = build_pack(config)
            reports.append(report)
            print(
                f"  OK: {report['lesson_count']} records, "
                f"{report['size_bytes']} ZIP bytes, "
                f"{report['copied_asset_count']} copied assets, "
                f"{report['missing_asset_count']} missing/ambiguous assets"
            )
            print(f"  ZIP: {report['zip']}")
        except Exception as error:
            errors.append({
                "pack_id": config["id"],
                "error": str(error),
            })
            print(f"  ERROR: {error}")

    summary = {
        "built_count": len(reports),
        "failed_count": len(errors),
        "packs": reports,
        "errors": errors,
    }

    summary_path = OUTPUT_ROOT / "batch_build_report.json"
    summary_path.write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    missing_rows = []
    for report in reports:
        missing_rows.extend(report["missing_assets"])

    missing_path = OUTPUT_ROOT / "missing_assets_report.json"
    missing_path.write_text(
        json.dumps(missing_rows, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print("\n===== BATCH SUMMARY =====")
    print(f"Built: {len(reports)} / {len(PACKS)}")
    print(f"Failed: {len(errors)}")
    print(f"Summary: {summary_path}")
    print(f"Missing assets: {missing_path}")

    if errors:
        raise SystemExit(1)


if __name__ == "__main__":
    main()








