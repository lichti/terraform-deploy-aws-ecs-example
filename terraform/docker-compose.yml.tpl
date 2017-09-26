version: '3'
services:
  web:
    build: .
    image: {{image_url}}
    ports:
     - "8000:80"
    environment:
      TOKEN: {{TOKEN}}
