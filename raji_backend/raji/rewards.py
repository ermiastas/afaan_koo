def calculate_reward(
    message: str,
    response: str,
) -> dict:
    """
    Raji does not freely choose rewards.

    Rewards are controlled by application rules.
    """

    return {
        "xp": 0,
        "stars": 0,
        "coins": 0,
    }


def learning_reward(
    xp: int = 5,
    stars: int = 0,
    coins: int = 0,
) -> dict:

    return {
        "xp": max(0, xp),
        "stars": max(0, stars),
        "coins": max(0, coins),
    }