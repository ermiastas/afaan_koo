import hashlib
import json
import shutil
import zipfile
from pathlib import Path

PROJECT = Path(__file__).resolve().parent.parent
SOURCE_JSON = PROJECT / "lib" / "content" / "alphabet" / "letters.json"
SOURCE_IMAGES = PROJECT / "assets" / "images" / "alphabet"
SOURCE_AUDIO = PROJECT / "assets" / "assets"
SOURCE_LETTER_AUDIO = SOURCE_AUDIO / "alphabet"

BUILD_ROOT = PROJECT / "build" / "content_packs" / "alphabet_v1"
PACK_ROOT = BUILD_ROOT / "pack"
LESSONS_DIR = PACK_ROOT / "lessons"
MEDIA_IMAGES_DIR = PACK_ROOT / "media" / "images"
MEDIA_AUDIO_DIR = PACK_ROOT / "media" / "audio"
ZIP_PATH = BUILD_ROOT / "alphabet_v1.zip"
REPORT_PATH = BUILD_ROOT / "alphabet_v1_build_report.json"

PACK_ID = "alphabet"
PACK_NAME = "Qubee Afaan Oromoo"
VERSION = 1
MIN_APP_VERSION = "1.0.0"
LANGUAGE = "om"


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

        entries.append((relative, path.read_bytes()))

    entries.sort(key=lambda item: item[0])
    payload = bytearray()

    for relative, content in entries:
        path_bytes = relative.encode("utf-8")
        payload.extend(len(path_bytes).to_bytes(8, "big"))
        payload.extend(path_bytes)
        payload.extend(len(content).to_bytes(8, "big"))
        payload.extend(content)

    return sha256_bytes(bytes(payload))


def find_media_file(filename: str, preferred_dir: Path) -> Path | None:
    if not filename:
        return None

    candidate = preferred_dir / Path(filename).name
    if candidate.is_file():
        return candidate

    # Handle the existing T example image filename without changing source JSON.
    if Path(filename).name.lower() == "tullu.png":
        fallback = preferred_dir / "tulluu.png"
        if fallback.is_file():
            return fallback

    return None


def copy_media(
    source: Path | None,
    destination_dir: Path,
    media_kind: str,
) -> str:
    if source is None or not source.is_file():
        return ""

    destination = destination_dir / source.name
    shutil.copy2(source, destination)
    return f"media/{media_kind}/{source.name}"


def main() -> None:
    if not SOURCE_JSON.is_file():
        raise FileNotFoundError(f"Missing source JSON: {SOURCE_JSON}")

    if not SOURCE_IMAGES.is_dir():
        raise FileNotFoundError(f"Missing image directory: {SOURCE_IMAGES}")

    letters = json.loads(SOURCE_JSON.read_text(encoding="utf-8"))
    if not isinstance(letters, list) or not letters:
        raise ValueError("letters.json must contain a non-empty JSON array")

    if BUILD_ROOT.exists():
        shutil.rmtree(BUILD_ROOT)

    LESSONS_DIR.mkdir(parents=True)
    MEDIA_IMAGES_DIR.mkdir(parents=True)
    MEDIA_AUDIO_DIR.mkdir(parents=True)

    rewritten = []
    missing_images = []
    missing_letter_audio = []
    missing_word_audio = []

    for index, letter in enumerate(letters, start=1):
        if not isinstance(letter, dict):
            raise ValueError(f"Letter entry {index} must be a JSON object")

        item = dict(letter)
        symbol = str(item.get("letter", "")).strip()
        if not symbol:
            raise ValueError(f"Letter entry {index} has no letter value")

        image_name = str(item.get("image", "")).strip()
        image_source = find_media_file(image_name, SOURCE_IMAGES)
        if image_source is None:
            missing_images.append({
                "letter": symbol,
                "file": image_name,
            })
        item["image"] = copy_media(
            image_source,
            MEDIA_IMAGES_DIR,
            "images",
        )

        letter_sound_name = str(item.get("sound", "")).strip()
        letter_sound_source = find_media_file(
            letter_sound_name,
            SOURCE_LETTER_AUDIO,
        )
        if letter_sound_source is None:
            letter_sound_source = find_media_file(
                letter_sound_name,
                SOURCE_AUDIO,
            )

        if letter_sound_source is None:
            missing_letter_audio.append({
                "letter": symbol,
                "file": letter_sound_name,
            })

        item["sound"] = copy_media(
            letter_sound_source,
            MEDIA_AUDIO_DIR,
            "audio",
        )

        word_sound_name = str(item.get("word_sound", "")).strip()
        word_sound_source = find_media_file(
            word_sound_name,
            SOURCE_AUDIO,
        )

        if word_sound_source is None:
            missing_word_audio.append({
                "letter": symbol,
                "file": word_sound_name,
            })

        item["word_sound"] = copy_media(
            word_sound_source,
            MEDIA_AUDIO_DIR,
            "audio",
        )

        rewritten.append(item)

    lesson_path = LESSONS_DIR / "alphabet.json"
    lesson_path.write_text(
        json.dumps(rewritten, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    content_checksum = canonical_content_checksum(PACK_ROOT)

    manifest = {
        "id": PACK_ID,
        "name": PACK_NAME,
        "version": VERSION,
        "min_app_version": MIN_APP_VERSION,
        "lesson_count": len(rewritten),
        "size_bytes": sum(
            path.stat().st_size
            for path in PACK_ROOT.rglob("*")
            if path.is_file()
        ),
        "language": LANGUAGE,
        "checksum": content_checksum,
        "is_active": True,
    }

    (PACK_ROOT / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

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

    report = {
        "pack_id": PACK_ID,
        "version": VERSION,
        "lesson_count": len(rewritten),
        "content_checksum_sha256": content_checksum,
        "zip_checksum_sha256": zip_checksum,
        "zip_size_bytes": ZIP_PATH.stat().st_size,
        "zip": str(ZIP_PATH),
        "missing_images": missing_images,
        "missing_letter_audio": missing_letter_audio,
        "missing_word_audio": missing_word_audio,
    }

    REPORT_PATH.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print("Alphabet pack generated successfully.")
    print(f"Letters: {len(rewritten)}")
    print(f"Missing images: {len(missing_images)}")
    print(f"Missing letter audio: {len(missing_letter_audio)}")
    print(f"Missing word audio: {len(missing_word_audio)}")
    print(f"Content checksum: {content_checksum}")
    print(f"ZIP checksum:     {zip_checksum}")
    print(f"ZIP size:         {ZIP_PATH.stat().st_size} bytes")
    print(f"ZIP:              {ZIP_PATH}")
    print(f"Report:           {REPORT_PATH}")


if __name__ == "__main__":
    main()
