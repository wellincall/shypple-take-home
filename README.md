# Shypple take home

To run this app, you need to have docker and docker compose installed in your machine.

After installing them, you can run the application with the following command:

```sh
$ docker compose up --build
```

Then you can access the application in `localhost:3000`

## Running tests

```sh
$ docker compose run web bundle exec rspec
```
