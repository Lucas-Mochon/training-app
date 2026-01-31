FROM ghcr.io/cirruslabs/flutter:latest

WORKDIR /app

COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

COPY . .

RUN flutter build web --release

RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*

EXPOSE 5000

WORKDIR /app/build/web

CMD ["python3", "-m", "http.server", "5000"]
