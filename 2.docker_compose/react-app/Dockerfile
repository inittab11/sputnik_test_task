FROM node:18-alpine
WORKDIR /app
RUN apk add --no-cache curl && npm install -g serve
ARG REACT_APP_TEST_VAR
ENV REACT_APP_TEST_VAR=${REACT_APP_TEST_VAR}
RUN ["/bin/sh","-c",": ${REACT_APP_TEST_VAR:?REACT_APP_TEST_VAR must be set}"]
COPY package*.json ./
RUN npm install --production
COPY . ./
RUN npm run build
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
