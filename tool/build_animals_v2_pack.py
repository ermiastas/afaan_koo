import hashlib
import json
import shutil
import zipfile
from pathlib import Path

PROJECT = Path(__file__).resolve().parent.parent
SOURCE_JSON = PROJECT / "lib" / "content" / "animals" / "animals.json"
SOURCE_IMAGES = PROJECT / "assets" / "images" / "animals"

BUILD_ROOT = PROJECT / "build" / "content_packs" / "animals_v2"
PACK_ROOT = BUILD_ROOT / "pack"
LESSONS_DIR = PACK_ROOT / "lessons"
MEDIA_IMAGES_DIR = PACK_ROOT / "media" / "images"
ZIP_PATH = BUILD_ROOT / "animals_v2.zip"


IMAGE_MAP = {
    "assets/images/animals/lion.png": "media/images/lion.png",
    "assets/images/animals/monkey.png": "media/images/monkey.png",
    "assets/images/animals/cow.png": "media/images/cow.png",
    "assets/images/animals/wild_dog.png": "media/images/wild_dog.png",
}


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_content_checksum(root: Path) -> str:
    entries = []

    for path in root.rglob("*"):
        if not path.is_file():
            continue

        relative = path.relative_to(root).as_posix()

        if relative == "manifest.json":
            continue

        content = path.read_bytes()
        entries.append((relative, content))

    entries.sort(key=lambda item: item[0])

    payload = bytearray()

    for relative, content in entries:
        path_bytes = relative.encode("utf-8")

        payload.extend(len(path_bytes).to_bytes(8, "big"))
        payload.extend(path_bytes)
        payload.extend(len(content).to_bytes(8, "big"))
        payload.extend(content)

    return sha256_bytes(bytes(payload))


def main() -> None:
    if not SOURCE_JSON.is_file():
        raise FileNotFoundError(f"Missing source JSON: {SOURCE_JSON}")

    if not SOURCE_IMAGES.is_dir():
        raise FileNotFoundError(f"Missing image directory: {SOURCE_IMAGES}")

    if BUILD_ROOT.exists():
        shutil.rmtree(BUILD_ROOT)

    LESSONS_DIR.mkdir(parents=True)
    MEDIA_IMAGES_DIR.mkdir(parents=True)

    animals = json.loads(SOURCE_JSON.read_text(encoding="utf-8"))

    if not isinstance(animals, list):
        raise ValueError("animals.json must contain a JSON array")

    if len(animals) != 19:
        raise ValueError(
            f"Expected 19 animals, found {len(animals)}"
        )

    rewritten = []

    for animal in animals:
        item = dict(animal)

        original_image = item.get("image", "")

        if original_image in IMAGE_MAP:
            destination_relative = IMAGE_MAP[original_image]
            source_name = Path(original_image).name

            source = SOURCE_IMAGES / {
                "lion.png": "Lion.png",
                "monkey.png": "Monkey.png",
                "cow.png": "Cow.png",
                "wild_dog.png": "wild_dog.png",
            }[source_name]

            if not source.is_file():
                raise FileNotFoundError(
                    f"Missing mapped image: {source}"
                )

            destination = PACK_ROOT / destination_relative
            shutil.copy2(source, destination)

            item["image"] = destination_relative

        else:
            source_name = Path(original_image).name
            source = SOURCE_IMAGES / source_name

            if source.is_file():
                destination = MEDIA_IMAGES_DIR / source_name
                shutil.copy2(source, destination)
                item["image"] = f"media/images/{source_name}"
            else:
                raise FileNotFoundError(
                    f"Animal image referenced by JSON does not exist: "
                    f"{original_image}"
                )

        # Animal audio files are not currently available in the project.
        # Preserve the source value instead of creating a false filesystem path.
        rewritten.append(item)

    lesson_path = LESSONS_DIR / "animals.json"
    lesson_path.write_text(
        json.dumps(
            rewritten,
            ensure_ascii=False,
            indent=2,
        ) + "\n",
        encoding="utf-8",
    )

    content_checksum = canonical_content_checksum(PACK_ROOT)

    manifest = {
        "id": "animals_v2",
        "name": "Uumama - Bineensa Koo",
        "version": 2,
        "min_app_version": "1.0.0",
        "lesson_count": len(rewritten),
        "size_bytes": sum(
            path.stat().st_size
            for path in PACK_ROOT.rglob("*")
            if path.is_file()
        ),
        "language": "om",
        "checksum": content_checksum,
        "is_active": True,
    }

    manifest_path = PACK_ROOT / "manifest.json"
    manifest_path.write_text(
        json.dumps(
            manifest,
            ensure_ascii=False,
            indent=2,
        ) + "\n",
        encoding="utf-8",
    )

    # Recalculate ZIP after manifest has been written.
    ZIP_PATH.parent.mkdir(parents=True, exist_ok=True)

    with zipfile.ZipFile(
        ZIP_PATH,
        "w",
        compression=zipfile.ZIP_DEFLATED,
    ) as archive:
        for path in sorted(PACK_ROOT.rglob("*")):
            if path.is_file():
                archive.write(
                    path,
                    path.relative_to(PACK_ROOT).as_posix(),
                )

    zip_checksum = sha256_bytes(ZIP_PATH.read_bytes())

    # Update a report rather than modifying the manifest checksum:
    # manifest checksum is deliberately the canonical content checksum,
    # while the ZIP checksum belongs to the server catalog.
    report = {
        "pack_id": "animals_v2",
        "version": 2,
        "lesson_count": len(rewritten),
        "content_checksum_sha256": content_checksum,
        "zip_checksum_sha256": zip_checksum,
        "zip_size_bytes": ZIP_PATH.stat().st_size,
        "zip": str(ZIP_PATH),
    }

    report_path = BUILD_ROOT / "animals_v2_build_report.json"
    report_path.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print("Animals pack generated successfully.")
    print(f"Lessons: {len(rewritten)}")
    print(f"Content checksum: {content_checksum}")
    print(f"ZIP checksum:     {zip_checksum}")
    print(f"ZIP size:         {ZIP_PATH.stat().st_size} bytes")
    print(f"ZIP:              {ZIP_PATH}")
    print(f"Report:           {report_path}")


if __name__ == "__main__":
    main()


