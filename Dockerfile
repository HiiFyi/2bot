FROM mysterysd/wzmlx:v3

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN uv venv --system-site-packages

ENV VENV_PATH=/opt/venv
RUN python3 -m venv $VENV_PATH
ENV PATH="$VENV_PATH/bin:$PATH"

COPY install.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/install.sh
RUN /usr/local/bin/install.sh

COPY requirements.txt .
RUN uv pip install --no-cache-dir -r requirements.txt

COPY --from=mwader/static-ffmpeg:7.1.1 /ffmpeg /bin/ffmpeg
COPY --from=mwader/static-ffmpeg:7.1.1 /ffprobe /bin/ffprobe
COPY . .

EXPOSE 8000
CMD ["python3", "cluster.py"]
