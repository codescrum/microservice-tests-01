# Microservices tests

This is a repo for microservice tests using rabbitmq.

## Instructions

1. [Install rabbitmq](https://www.rabbitmq.com/download.html)
2. Clone this repo
```bash
git clone git@github.com:gato-omega/microservices-tests.git
```
3. go into directory
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
```bash
ruby logger.rb
```
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


  ## Interesting this you can do now

  1. Leave the system running and see how it behaves (basically is a message passing game)
  2. Using the keyboard client, put various messages with multiple dots "." to simulate load for the workers.
  3. Turn off services randomly and rerun them, you will see how messages are queued and processed when the microservices become available again.
  4. Enjoy!
