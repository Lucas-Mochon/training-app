FROM ghcr.io/cirruslabs/flutter:latest as builder

WORKDIR /app

COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

COPY . .
RUN flutter build web --release --no-tree-shake-icons

FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /app/build/web ./

EXPOSE 5000

CMD ["python3", "-m", "http.server", "5000", "--directory", "."]
