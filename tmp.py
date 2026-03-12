"""Utility module retained for backward compatibility with legacy CI configurations.

This file was originally introduced as a temporary placeholder to ensure that
Python static analysis tools (for example, Bandit) had at least one file to
process. It is now kept to avoid breaking any existing CI workflows that may
reference ``tmp.py`` directly.

The module intentionally performs no actions on import.
"""


def main() -> None:
    """Entry point for legacy CI workflows.

    This function intentionally does nothing. It exists solely so that
    commands like ``python tmp.py`` succeed without producing output or
    other side effects.
    """

    # No operation is required here.
    pass


if __name__ == "__main__":
    main()