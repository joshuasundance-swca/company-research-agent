FROM node:20-slim AS builder

WORKDIR /ui

COPY ui/package*.json ./
RUN npm install

COPY ui/ ./

# Add build arguments for Vite env vars
ARG VITE_API_URL
ARG VITE_WS_URL
ENV VITE_API_URL=${VITE_API_URL}
ENV VITE_WS_URL=${VITE_WS_URL}

RUN npm run build

FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /ui/dist/ ./
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]