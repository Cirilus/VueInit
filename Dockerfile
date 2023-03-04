# stage1 as builder
FROM node:alpine as builder

WORKDIR /app

# Copy the package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy rest of the files
COPY . .

# Build the project
RUN npm run build


FROM nginx:alpine as production-build

RUN mkdir /app
COPY docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /app

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]