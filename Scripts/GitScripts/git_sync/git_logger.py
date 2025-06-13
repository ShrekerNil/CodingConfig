import logging
import sys
from pathlib import Path
from typing import Optional


class ColorFormatter(logging.Formatter):
    COLORS = {
        'DEBUG': '\033[94m',
        'INFO': '\033[36m',
        'WARNING': '\033[33m',
        'ERROR': '\033[31m',
        'CRITICAL': '\033[41m',
        'RESET': '\033[0m'
    }

    def format(self, record):
        color = self.COLORS.get(record.levelname, '')
        message = super().format(record)
        if color and sys.stderr.isatty():
            return f"{color}{message}{self.COLORS['RESET']}"
        return message


def setup_logger(name: str, log_file: Optional[Path] = None):
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)

    # 控制台 Handler
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(ColorFormatter(
        fmt='%(asctime)s [%(name)s] - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    ))
    logger.addHandler(console_handler)

    # 文件 Handler
    if log_file:
        file_handler = logging.FileHandler(log_file)
        file_handler.setFormatter(logging.Formatter(
            fmt='%(asctime)s [%(name)s] - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        ))
        logger.addHandler(file_handler)

    return logger
