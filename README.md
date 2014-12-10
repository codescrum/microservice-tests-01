# Microservices tests

## Instructions

1. Install rabbitmq
2. Clone this repo
3. do bundle install
4. run ruby lib/bunny_keyboard.rb
5. Type in the console any input, messages will be queued until a worker appears
6. run ruby lib/receive.rb multiple times to spawn multiple workers
7. Keep typing and see the workload being balanced in a round-robin manner.
8. Enjoy!
