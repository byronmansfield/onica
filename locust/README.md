# Onica Locust Stress Test

This project is for simulating user traffic to display the projects autoscaling.


## Setup

You can set this up locally or run it in docker. You can also run this on a single
instance ("standalone mode") or in a distributed mode. For this example we are
going to do it in distributed mode because it is recommended by locust for more
accurate testing to simulate real traffic.


### Locally

```bash
mkdir -p locust-test && cd $_
pip install --user virtualenv
virtualenv -p python3.7 venv
source venv/bin/activate
pip install locustio
```

Now the project is set up locally. See the next steps for running the tests


### Docker

It is fairly simple to build and run this in/with docker & docker-compose. First
you will need to build the docker image then continue below in the run section

```bash
docker build -t onica:locust .
```

Or use the `Makefile`

```bash
make
```


## Run

You can run this locally or through docker-compose


### Locally

Because we are running this in distributed mode, you will need to run this in
multiple shell tty's

For the master run

```bash
locust -f locustfile.py --host=https://some-url.com --master
```

For the slave run

```bash
locust -f locustfile.py --host=https://some-url.com --slave
```

Repeat the above slave for as many slaves as you want. Recommended at least 2


### Docker Compose

It is fairly simple to run this with docker-compose once you have built the docker
image. Keep in mind you can run this against dev or production. There is also a
helpful `Makefile` to run these commands even easier.

```bash
docker-compose -f docker-compose-dev.yml up -d
```

Or with `make`

```bash
make run
```


#### Scaling the slaves

If you need to scale out more slave containers you can run the following.

```bash
docker-compose scale slave=5
```


## Testing

Now that we are up and running, you can start testing. Navigate to `localhost:8089`
in your browser.

Fill in how many users you want to simulate, and how many users to add every second
until it reaches the max.


## Stopping the tests

Before you `Ctrl+c` or `make stop`/`docker-compose -f docker-compose.yml down`,
you should stop the testing in the locust interface (upper right hand corner),
and let the testing finish.

