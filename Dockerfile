FROM python:3.13.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_CACHE_DIR=/opt/base/.uv-cache \
    VIRTUAL_ENV=/opt/base/.venv \
    PATH=/opt/base/.venv/bin:$PATH \
    BASH_ENV=/etc/profile.d/base-venv.sh

WORKDIR /opt/base

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-install-project
RUN mkdir -p /app && ln -s /opt/base/.venv /app/.venv
RUN printf '%s\n' \
    'export VIRTUAL_ENV=/opt/base/.venv' \
    'export PATH=/opt/base/.venv/bin:$PATH' \
    > /etc/profile.d/base-venv.sh
RUN printf '%s\n' \
    'export VIRTUAL_ENV=/opt/base/.venv' \
    'export PATH=/opt/base/.venv/bin:$PATH' \
    '[ -f /etc/profile.d/base-venv.sh ] && . /etc/profile.d/base-venv.sh' \
    >> /root/.bashrc

WORKDIR /app

CMD ["python", "--version"]
