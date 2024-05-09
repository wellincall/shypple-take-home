This project was developed using Ruby 3.3.1 and Rails 7.1.3.2.

No database was setup in here due to not having the need to store data from user. All data was already available in the file `response.json`.

# Running the application

In order to have a smoother experience running this project, it is necessary to have Docker and Docker compose installed in your local machine.

After you have them installed, you can start the project by running:

```sh
$ docker compose up --build
```

Then you can check the logs of the rails server in your terminal

The application will be available on `localhost:3000`.

You then have access to the following endpoints:

```
/api/v1/direct_sailings
/api/v1/cheapest_sailings
/api/v1/fastest_sailings
```

All of them need to receive the query params `origin` and `destination` in order to check the corresponding type of sailing requested. When any of them is not provided, the corresponding endpoint returns a response with HTTP status 400 (bad request).

## Running tests added to the project

If you want to check which tests were written in the project, you need to run the following command in a terminal:

```sh
$ docker compose exec web bundle exec rspec
```

Then a list of the tests added to the project is going to be displayed to you

