import os
import uuid
from datetime import datetime, timezone

from dotenv import load_dotenv
from fastapi import FastAPI
from pydantic import BaseModel, Field

from raji.model import RajiModel
from raji.prompt import RAJI_SYSTEM_PROMPT
from raji.safety import (
    is_safe_message,
    safety_response,
)
from raji.rewards import (
    calculate_reward,
)


load_dotenv()


# =====================================================
# CONFIGURATION
# =====================================================

MODEL_URL = os.getenv(
    "RAJI_MODEL_URL",
    "http://localhost:11434",
)

MODEL_NAME = os.getenv(
    "RAJI_MODEL",
    "qwen3:8b",
)


# =====================================================
# APPLICATION
# =====================================================

app = FastAPI(
    title="Raji AI API",
    description="Raji AI Assistant for AfaanKoo",
    version="1.0.0",
)


model = RajiModel(
    ollama_url=MODEL_URL,
    model_name=MODEL_NAME,
)


# =====================================================
# REQUEST MODEL
# =====================================================

class ChatRequest(BaseModel):

    message: str

    profile: dict = Field(
        default_factory=dict
    )

    history: list[dict] = Field(
        default_factory=list
    )


# =====================================================
# HEALTH CHECK
# =====================================================

@app.get("/api/raji/health")
async def health():

    return {
        "status": "ok",
        "assistant": "Raji",
        "model": MODEL_NAME,
    }


# =====================================================
# CHAT
# =====================================================

@app.post("/api/raji/chat")
async def chat(
    request: ChatRequest,
):

    message = request.message.strip()

    # -------------------------------------------------
    # Empty message
    # -------------------------------------------------

    if not message:

        return {
            "id": str(uuid.uuid4()),
            "role": "assistant",
            "message": (
                "Mee waan tokko na gaafadhu! 😊"
            ),
            "timestamp": _timestamp(),
            "reward": {
                "xp": 0,
                "stars": 0,
                "coins": 0,
            },
            "action": {},
            "suggestions": [
                "Hibboo naaf kenni 🧩",
                "Qubee na barsiisi 🔤",
                "Seenaa naaf himi 📖",
            ],
        }

    # -------------------------------------------------
    # Safety
    # -------------------------------------------------

    if not is_safe_message(message):

        return {
            "id": str(uuid.uuid4()),
            "role": "assistant",
            "message": safety_response(),
            "timestamp": _timestamp(),
            "reward": {
                "xp": 0,
                "stars": 0,
                "coins": 0,
            },
            "action": {},
            "suggestions": [
                "Hibboo naaf kenni 🧩",
                "Qubee na barsiisi 🔤",
            ],
        }

    # -------------------------------------------------
    # Child profile
    # -------------------------------------------------

    profile = request.profile

    context = build_context(
        profile
    )

    # -------------------------------------------------
    # Conversation history
    # -------------------------------------------------

    messages = []

    for item in request.history:

        role = item.get(
            "role",
            "user",
        )

        text = item.get(
            "message",
            "",
        )

        if not text:
            continue

        if role not in {
            "user",
            "assistant",
        }:
            continue

        messages.append({
            "role": role,
            "content": text,
        })

    # -------------------------------------------------
    # Current message
    # -------------------------------------------------

    messages.append({
        "role": "user",
        "content": (
            context
            + "\n\n"
            + "Gaaffii daa'imaa:\n"
            + message
        ),
    })

    # -------------------------------------------------
    # Generate response
    # -------------------------------------------------

    try:

        answer = await model.generate(
            system_prompt=RAJI_SYSTEM_PROMPT,
            messages=messages,
        )

    except Exception:

        return {
            "id": str(uuid.uuid4()),
            "role": "assistant",
            "message": (
                "Dhiifama! Raji amma "
                "si bira gahuu hin dandeenye. "
                "Mee xiqqoo booda yaali. 😊"
            ),
            "timestamp": _timestamp(),
            "reward": {
                "xp": 0,
                "stars": 0,
                "coins": 0,
            },
            "action": {},
            "suggestions": [],
        }

    # -------------------------------------------------
    # Validate response
    # -------------------------------------------------

    if not answer:

        answer = (
            "Mee irra deebi'ii na gaafadhu! 😊"
        )

    # -------------------------------------------------
    # Reward
    # -------------------------------------------------

    reward = calculate_reward(
        message,
        answer,
    )

    # -------------------------------------------------
    # Response
    # -------------------------------------------------

    return {
        "id": str(uuid.uuid4()),

        "role": "assistant",

        "message": answer,

        "timestamp": _timestamp(),

        "reward": reward,

        "action": {},

        "suggestions": [
            "Gaaffii biraa naaf kenni 😊",
            "Hibboo naaf kenni 🧩",
            "Seenaa gabaabaa naaf himi 📖",
        ],
    }


# =====================================================
# CONTEXT
# =====================================================

def build_context(
    profile: dict,
) -> str:

    progress = profile.get(
        "progress",
        {},
    )

    return f"""
HAALA BARATAA:

Maqaa:
{profile.get("nickname", "Barataa")}

Avatar:
{profile.get("avatar", "😊")}

Umrii:
{profile.get("ageGroup", "6-8")}

Barnoota amma jiru:
{profile.get("currentLesson", "Hin beekamne")}

Gosa barnootaa:
{profile.get("currentCategory", "Hin beekamne")}

Waan amma irratti hojjetamu:
{profile.get("currentItem", "Hin beekamne")}

XP:
{progress.get("xp", 0)}

Coins:
{progress.get("coins", 0)}

Stars:
{progress.get("stars", 0)}

Level:
{progress.get("level", 1)}

Barnoota xumurame:
{progress.get("completedLessons", 0)}

Taphoota xumuraman:
{progress.get("completedGames", 0)}

Daqiiqaa barnootaa:
{progress.get("learningMinutes", 0)}

% xumura:
{progress.get("completionPercentage", 0)}
"""


# =====================================================
# TIMESTAMP
# =====================================================

def _timestamp() -> str:

    return datetime.now(
        timezone.utc
    ).isoformat()