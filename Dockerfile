FROM --platform=${BUILDPLATFORM} golang:1.23-bookworm@sha256:3149bc5043fa58cf127fd8db1fdd4e533b6aed5a40d663d4f4ae43d20386665f AS builder

ARG TARGETARCH
ENV CGO_ENABLED=0
ENV GOARCH="${TARGETARCH}"
ENV GOOS=linux

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download
COPY cmd ./cmd
COPY pkg ./pkg
COPY main.go ./
RUN go build -ldflags="-w -s" -o dist/ts-auth-server main.go


FROM scratch

COPY --from=builder /build/dist/ts-auth-server /ts-auth-server
ENTRYPOINT [ "/ts-auth-server" ]
