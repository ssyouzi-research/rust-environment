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
    echo 'export PATH=/usr/local/cargo/bin:$PATH' >> /home/vscode/.bashrc &&\
    pip install --no-cache-dir -r requirements.txt &&\
    curl -fsSL https://code-server.dev/install.sh | sh &&\
    /usr/local/cargo/bin/cargo install evcxr_jupyter &&\
    python -m bash_kernel.install

EXPOSE 8080

USER vscode
RUN /usr/local/cargo/bin/evcxr_jupyter --install

CMD ["code-server"]
