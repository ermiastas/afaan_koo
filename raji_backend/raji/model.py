import httpx


class RajiModel:
    """
    Adapter between Raji API and the open-source LLM.

    Currently designed for Ollama.
    The model can be changed without changing
    the Flutter application.
    """

    def __init__(
        self,
        ollama_url: str,
        model_name: str,
    ):
        self.ollama_url = ollama_url.rstrip("/")
        self.model_name = model_name

    async def generate(
        self,
        system_prompt: str,
        messages: list[dict],
    ) -> str:

        payload = {
            "model": self.model_name,
            "stream": False,
            "messages": [
                {
                    "role": "system",
                    "content": system_prompt,
                },
                *messages,
            ],
        }

        async with httpx.AsyncClient(
            timeout=120.0
        ) as client:

            response = await client.post(
                f"{self.ollama_url}/api/chat",
                json=payload,
            )

            response.raise_for_status()

            data = response.json()

        message = data.get(
            "message",
            {},
        )

        return message.get(
            "content",
            "",
        ).strip()