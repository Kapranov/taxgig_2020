# TalkJob

**TODO: Add description**


```bash
bash> mix ecto.gen.migration -r TalkJob.Repo add_uuid_generate_v4_extension
bash> mix ecto.gen.migration -r TalkJob.Repo create_projects
bash> mix ecto.gen.migration -r TalkJob.Repo create_rooms
bash> mix ecto.gen.migration -r TalkJob.Repo create_messages
bash> mix ecto.gen.migration -r TalkJob.Repo add_tasks
```

```bash
bash> cd umbrella_apps
bash> ./run.sh
```

```
console> current_user1 = Core.Repo.get_by(Core.Accounts.User, email: "lugatex@yahoo.com")
console> current_user2 = Core.Repo.get_by(Core.Accounts.User, email: "o.puryshev@gmail.com")

console> {:ok, producer1} = TalkJob.Producer.start_link(current_user1)
console> {:ok, producer2} = TalkJob.Producer.start_link(current_user2)

console> {:ok, producer_consumer1} = TalkJob.ProducerConsumer.start_link(producer1, current_user1)
console> {:ok, producer_consumer2} = TalkJob.ProducerConsumer.start_link(producer2, current_user2)

console> {:ok, consumer1} = TalkJob.Consumer.start_link(producer_consumer1, current_user1)
console> {:ok, consumer2} = TalkJob.Consumer.start_link(producer_consumer2, current_user2)

console> {:ok, producer1} = TalkJob.open(current_user1)
```

### Introduction

Back-pressure is a technique utilized to prevent an application or a
piece of software of using more resources than there are available on a
given infrastructure.

GenStage is an Elixir library to build complex processes divided by
steps (or stages) that share data between them. This is the core
behaviour used on
Broadway, a multi-stage data ingestion backed on message queue systems
such as Kafka, RabbitMQ and others.

### The problem

Suppose you've built a news sharing system which is composed of three
main components:

- Data ingestor (A): constantly searches and downloads tweets that
  contains hashtags of interest, such as #computerscience, #architecture
  and #programming.
- Republisher (B): takes a tweet content, renders it on several
  different formats (HTML, Markdown, PDF and so on) and then publishes
  on different platforms.
- Reporter (C): writes to database the timestamps of each publishing and
  also exports metrics to be analyzed on the future.

```
A ----> B ----> C
```

The process being executed on component A is simple and takes only a
single request to be done: a GET on Twitter's API. For this action we
will account an imaginary measurement of 1N amount of energy to get
done.

Now that a tweet content is retrieved and delivered to component B, a
more complex process starts: it is required to transform the data
acquired on several different formats and then make several other
requests to external services (which may or not fail, timeout or take
several more amount of time than usual). For this step then we will
account 10N amount of energy taken.

Component C executes a simpler process as well since it only does a
write operation on database and then create telemetry data that will be
polled later. That's 2N amount of energy on our example.

As you can imagine, this scenario is problematic because component A
generates input for component B on a speed ratio that it can't absorb,
and that generates a overflow on B's execution queue.

```
  Tweet
  Tweet
  Tweet
  Tweet
  Tweet
  Tweet
  Tweet      Content    Metrics
A -------> B -------> C
```

### The solution

GenStage strategy to apply back-pressure is to invert the flow direction
from the producer to the consumer and so consumers now control the
velocity and amount of data transmitted.

Component C starts with its execution queue empty and then asks
Component B (which is a consumer-producer) to produce a piece of data.

Component B which also has it's execution queue empty now asks
Component A to produce a piece of data and only then the Tweeter API is
called!

The amount of data produced is back-pressured so no queues gets
overflowed and that's how you have a healthy workflow on Elixir using
GenStages.

```
  Tweet   Content   Metrics
A <---- B <------ B <------ C
```

### Terms

GenServer: A generic server. A microservice, if you will, within your
VM. Use it for anything where you have a need to serialize access to a
resource. This could represent a player in a game, a character logged
into a game, a game board, a car in a simulation, and so on. Anything
where you need a single point to funnel logic through for
access/timing/whatever. Usually pools of workers are genservers, for
example.

Agent: A process for holding shared state for quick, serialized, access.
This is effectively just a dummy data container that you hand the
functions that tell it what to do with the data at the same time that
you are working with it. Good for lightweight data sharing that for some
reason needs to be in its own process but still with serialized access
to data.

Task: A process designed to handle a one-off task before shutting down
and returning whatever results. Has a special task supervisor which
makes it easy to dynamically spawn and monitor tasks.

Supervisor: Supervises processes with configuration which determines
if/when/how a process that it is supervising is restarted. These should
be used, either via explicit or dynamic or task supervisors, to
supervise almost all of your processes. You almost always want your
worker processes supervised in some way.

- Lists stage (producer): retrieves all the rooms
- Update stage (producer/consumer): updated all rooms
- Final stage (consumer): retries a final result

### 5 Oct 2022 by Oleg G.Kapranov

 [1]: https://medium.com/@andreichernykh/elixir-a-few-things-about-genstage-id-wish-to-knew-some-time-ago-b826ca7d48ba
 [2]: https://10consulting.com/2017/01/20/building-product-recommendations-using-elixir-gen-stage-flow/
 [3]: http://big-elephants.com/2019-01/facebook-genstage/
 [4]: https://blog.appsignal.com/2019/12/12/how-to-use-broadway-in-your-elixir-application.html
 [5]: https://github.com/jdanderson2/sqs_pipeline
 [6]: https://github.com/mariogmarq/TestGenStage
 [7]: https://github.com/peterkrenn/ecto-genstage-batcher-example
 [8]: https://github.com/SophieDeBenedetto/slow_greeter
 [9]: https://github.com/enelesmai/genstage-concurrent-data
[10]: https://github.com/ybur-yug/genstage_example
[11]: https://github.com/dashbitco/flow
[12]: https://github.com/antonmi/flowex
[13]: https://github.com/cloud8421/osteria
[14]: https://gist.github.com/ybur-yug/17593fa6923255c227458b871f095327
[15]: https://blog.appsignal.com/2019/08/13/elixir-alchemy-multiplayer-go-with-registry-pubsub-and-dynamic-supervisors.html
[16]: https://github.com/SophieDeBenedetto/slow_greeter
[17]: https://levelup.gitconnected.com/genserver-dynamicsupervisor-and-registry-the-elixir-triad-to-manage-processes-a65d4c3351c1
[18]: https://rafaelantunes.com.br/what-is-genstage
[19]: https://samuelmullen.com/articles/elixir-processes-linking-and-monitoring/
[20]: https://samuelmullen.com/articles/understanding-elixirs-broadway/
[21]: https://thoughtbot.com/blog/how-to-start-processes-with-dynamic-names-in-elixir
[22]: https://samuelmullen.com/articles/elixir-processes-observability/
[23]: https://www.openmymind.net/Elixir-A-Little-Beyond-The-Basics-Part-6-processes/
[24]: https://elixirforum.com/t/genstage-dynamic-producers/19768
[25]: https://github.com/elixir-lang/gen_stage/blob/main/lib/gen_stage.ex
[26]: https://github.com/elixir-lang/gen_stage/blob/main/test/gen_stage_test.exs
[27]: https://github.com/Kapranov/test_super
[28]: https://github.com/Kapranov/gen_server_try
[29]: https://github.com/Kapranov/genstage_playground
[30]: https://github.com/Kapranov/GenStage
[31]: https://github.com/Kapranov/gen_stage_test
[32]: https://github.com/Kapranov/eth_sync
[33]: https://github.com/Kapranov/test_super
[34]: https://github.com/Kapranov/recurring-genserver
