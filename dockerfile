FROM mcr.microsoft.com/devcontainers/python:3.14-bookworm

WORKDIR /root

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo

COPY requirements.txt .
RUN apt update &&\
    apt upgrade -y &&\
    apt install pandoc texlive-xetex texlive-fonts-recommended texlive-plain-generic texlive-lang-japanese -y &&\
    curl -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path &&\
    chown -R vscode:vscode /usr/local/rustup /usr/local/cargo &&\
    pip install --no-cache-dir -r requirements.txt &&\
    curl -fsSL https://code-server.dev/install.sh | sh &&\
    /usr/local/cargo/bin/cargo install evcxr_jupyter &&\
    /usr/local/cargo/bin/evcxr_jupyter --install &&\
    python -m bash_kernel.install

EXPOSE 8080

CMD ["code-server"]
