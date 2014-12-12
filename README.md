# Microservices tests

This is a repo for microservice tests using rabbitmq.

## Instructions

1. [Install rabbitmq](https://www.rabbitmq.com/download.html)
2. Clone this repo
3. go into the cloned project directory

  ```bash
  cd microservices-tests
  ```
4. do bundle install

  ```bash
  bundle install
  ```
5. cd into lib, where all the exectuables are, from now on, you will execute any commands in different terminals, keeping the processes (microservices) alive.

  ```bash
  cd lib
  ```
6. edit configuration.rb to set the connection url to the rabbitmq server if necessary (just in case you are using non-default values for the ports, user, password, etc.)
7. run the keyboard client, so you can type messages, hit enter to send. Messages will be
   queued in rabbitmq until a consumer appears

  ```bash
  ruby keyboard_client.rb
  ```
8. run the first service (queue_a) which takes messages and replays them to the workers

  ```bash
  ruby queue_a.rb
  ```
9. run ANY number of workers. In order to control how much time workers perform a task, just type dots "." in the message you send using the keyboard client, example: "Hello!...." will take 4 seconds to process, because it has 4 dots ".".

  ```bash
  ruby worker.rb
  ```
9. Run the receiver, which is the last stop for processed messages. Processed messages are the ones that have any digits in the message body, complying to the pattern /\d/. Processed messages are upcased.

  ```bash
  ruby receiver.rb
  ```
10. Run the logger, which will log the important interactions in the system. The other microservices send messages to the "logger" queue for this.

  ```bash
  ruby logger.rb
  ```
11. Finally, in order to not input messages manually, run:

  ```bash
  ruby auto_client.rb
  ```
  This will basically send a message to "queue_a" every second so you can see how the overall system works by looking a the various console outputs for each of the microservices.


## Interesting thing you can do now

  1. Leave the system running and see how it behaves (basically is a message passing game)
  2. Using the keyboard client, put various messages with multiple dots "." to simulate load for the workers.
  3. Turn off services randomly and rerun them, you will see how messages are queued and processed when the microservices become available again.
  4. Enjoy!


## Running each micro-service in docker container

This steps assume you have docker installed and working in your system.

### Run RabbitMQ Server

1. Create and image for rabbitmq server:

  ```bash
  docker build -t="dockerfile/rabbitmq" github.com/dockerfile/rabbitmq
  ```
2. Run a container from that image with:

  ```bash
  run --name rabbitmq -d -p 5672:5672 -p 15672:15672 dockerfile/rabbitmq
  ```

### Run microservices in docker

1. Create and image for micro-services (with ruby 2.1.1 and microservices bundle) doing:

  ```bash
  docker build -t="microservices/client" .
  ```
2. Run each microservice in a terminal as in steps 7 to 11 of the **Instructions** part, replacing *microservice.rb* with the corresponding ruby file.

  ```bash
   docker run --link rabbitmq:amq -t -i microservices/client ruby lib/microservice.rb
  ```

