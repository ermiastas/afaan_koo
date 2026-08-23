BLOCKED_PATTERNS = [
    "how to make a bomb",
    "how to make a weapon",
    "how to hurt someone",
]


def is_safe_message(message: str) -> bool:
    """
    Basic first-layer safety filter.

    This is not a replacement for proper
    child-safety moderation.
    """

    normalized = message.lower().strip()

    for pattern in BLOCKED_PATTERNS:

        if pattern in normalized:
            return False

    return True


def safety_response() -> str:
    return (
        "Dhiifama, waa'ee kanaa si gargaaruu hin danda'u. "
        "Mee waa barnootaa ykn taphaa biraa haa ilaallu! 😊"
    )