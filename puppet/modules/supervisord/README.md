puppet-supervisord
==================

Puppet module for managing supervisord package, config, and service.

# Quick Start

This creates 5 instances of a useless uses of cat running in the background.

<pre>
include apt
include supervisord

supervisord::resource::program {'cat':
  command      => '/bin/cat',
  process_name => '%(process_num)s',
  numprocs     => 5,
}
</pre>
