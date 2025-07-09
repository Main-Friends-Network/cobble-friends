# ---- Build Stage -----------------------------------------------------------
FROM golang:1.24-alpine AS builder

# Packwiz aus den Quellen ziehen & kompilieren
RUN go install github.com/packwiz/packwiz@latest  \
    # ZIP-Tools sind praktisch für Exporte
 && apk add --no-cache zip unzip

# ---- Runtime Stage ---------------------------------------------------------
FROM alpine:3.20

RUN apk add --no-cache ca-certificates git zip unzip
COPY --from=builder /go/bin/packwiz /usr/local/bin/packwiz

# Standard-Arbeitsordner → wird später mit -v gemountet
WORKDIR /workspace
ENTRYPOINT ["packwiz"]