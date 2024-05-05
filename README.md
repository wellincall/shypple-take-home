# Shypple take home

To run this app, you need to have docker and docker compose installed in your machine.

After installing them, you can run the application with the following command:

```sh
$ docker compose up --build
```

Then you can access the application in `localhost:3000`

**At the moment, only the endpoint for direct sailings was implemented**

Due to time constraints, I couldn't finish the minimal tasks.

## Running tests

```sh
$ docker compose run web bundle exec rspec
```
