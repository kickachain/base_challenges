FROM python:3.13.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_CACHE_DIR=/opt/base/.uv-cache \
    VIRTUAL_ENV=/opt/base/.venv \
    PATH=/opt/base/.venv/bin:$PATH \
    SHELL=/bin/zsh

RUN apt-get update \
    && apt-get install -y --no-install-recommends zsh \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/base

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-install-project
RUN mkdir -p /app && ln -s /opt/base/.venv /app/.venv
RUN printf '%s\n' \
    'export VIRTUAL_ENV=/opt/base/.venv' \
    'export PATH=/opt/base/.venv/bin:$PATH' \
    >> /root/.zshrc

WORKDIR /app

CMD ["python", "--version"]
