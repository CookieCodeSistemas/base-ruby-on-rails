# Base RubyOnRails

![Docker Rails Image CI](https://github.com/CookieCodeSistemas/base-ruby-on-rails/workflows/Docker%20Rails%20Image%20CI/badge.svg)

This project dont has a default project already created, you must to create a project how do you need!

### Requirements

+ Docker
+ Docker Compose

### What this image contains

+ Ruby
+ Ruby On Rails
+ Bundler

### How to use this image

Add in your `docker-compose.yml` like this:

```yalm

  db:
    image: postgres
    container_name: project_db
    ports:
      - 5432:5432
    tty: true
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres

  api:
    build: .
    container_name: project_api
    ports:
      - 80:3000
    volumes:
      - ./projects/back:/var/www
      - .bundle:/usr/local/bundle
      - .coverage:/var/www/.coverage
    stdin_open: true
    tty: true
    links:
      - db

```

Create your project

RUN: 
+ for simple project `docker-compose exec api rails new blog` 
+ for only rest api`docker-compose exec api rails new blog --api`
+ or entry in container to create your project
    + `docker exec -it project_api /bin/bash`
    + `rails new blog`
