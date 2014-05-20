# RabbitMQ leak VM

Spin up the VM with a standrd _vagrant up_ command.

This box contains:

  . RabbitMQ server + stomp
  . Mcollective server(s)
  . Mcollective client(s)

so will come up and do an mcollective soak/stress test.

Boot and observe the rabbitmq memory useage once it gets to steady state
(a couple of min after provisioning is done). Ignore for 5 or 6 hours,
then re-observe the memory useage - note that it's signifcantly higher,
even though the client count and workload stays flat.

If left alone eventually the RabbitMQ instance will run out of RAM
and start dropping new connections (when the high mem watermark
is reached).

Expects to be run on virtualbox, but the only VB specific tweak
is the memory (to 2Gb).

Binds port 15672 (rabbitmq admin) to localhost so that you can
browse to the management interface whilst the stress 

Log into the management interface with:

    Username: admin
    Password: admin

Puppet code to set this box up is in manifests/site.pp

There are a selection of tuneables to allow you to vary the number of
servers and clients, + the inerval for heartbeat and registration
messages.

As setup currently this mimics all the features and versions used
in our production deployment (except that federation isn't actually used).

I'm not currently sure which part of the workload causes the leaking,
however I'll be trying to identify this now that I have something which
can reproduce it.

