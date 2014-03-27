# Webtest: 0

# Goal

Before to start I need to have very clear what is my goal. At least, my most immediate one. In this case it will be to be able to start to work and test my ideas.

So the first thing is to install the needed tools:

* Test-Kitchen
* Vagrant
* ServerSpec

I have already installed **Vagrant** and I use it with **LXC** (thanks to the great *Fabio Rehm*'s plugin [vagrant-lxc][1]) because it's much much faster than *VirtualBox*, so I skipped that part.

> **IMPORTANT NOTE:**
> The plugin `vagrant-lxc` uses `sudo` a lot and it could ask you for the password too many times. There is a workaround for the issue:
> https://github.com/fgrehm/vagrant-lxc/wiki/Avoiding-%27sudo%27-passwords

As my very first goal is to have the minimal tooling ready to try something, I'd say that my **DoD** (*Definition of Done*) here is that I'm able to test the simplest cookbook possible with Test-kitchen:
> cookbook with an **empty recipe** and the **basic metadata file**.

This is how the minimal skeleton would look like:

```
webtest-0/
├── Gemfile
├── .kitchen.yml
├── metadata.rb
├── README.md
└── recipes
    └── default.rb

```

## Test that everything is in place

The content of the files are pretty simple and easy to understand so I won't explain them.

To install the tools, dependencies and check that everything is in order I'll run this:
```
$ bundle
... (here goes the bundle output)
$ bundle exec kitchen converge
```

After that, `kitchen` will set up a virtual machine with Vagrant and LXC and run chef-solo with my empty recipe. And the output will be something like this:
```
-----> Starting Kitchen (v1.2.1)
-----> Cleaning up any prior instances of <default-ubuntu-1204>
-----> Destroying <default-ubuntu-1204>...
       Finished destroying <default-ubuntu-1204> (0m0.00s).
-----> Testing <default-ubuntu-1204>
-----> Creating <default-ubuntu-1204>...
       Bringing machine 'default' up with 'lxc' provider...
       [default] Importing base box 'ubuntu-12.04-i386'...
       [Berkshelf] Skipping Berkshelf with --no-provision
       [default] Setting up mount entries for shared folders...
       [default] Starting container...
[default] Waiting for machine to boot. This may take a few minutes...       [default] Machine booted and ready!
       [default] Setting hostname...
       Vagrant instance <default-ubuntu-1204> created.
       Finished creating <default-ubuntu-1204> (0m27.37s).
-----> Converging <default-ubuntu-1204>...
       Preparing files for transfer
       Preparing current project directory as a cookbook
       Removing non-cookbook files before transfer
       Transfering files to <default-ubuntu-1204>
       [2014-03-21T16:07:52+00:00] INFO: Forking chef instance to converge...
       Starting Chef Client, version 11.6.0
       [2014-03-21T16:07:52+00:00] INFO: *** Chef 11.6.0 ***
       [2014-03-21T16:07:53+00:00] INFO: Setting the run_list to ["recipe[webtest::default]"] from JSON
       [2014-03-21T16:07:53+00:00] INFO: Run List is [recipe[webtest::default]]
       [2014-03-21T16:07:53+00:00] INFO: Run List expands to [webtest::default]
       [2014-03-21T16:07:53+00:00] INFO: Starting Chef Run for default-ubuntu-1204
       [2014-03-21T16:07:53+00:00] INFO: Running start handlers
       [2014-03-21T16:07:53+00:00] INFO: Start handlers complete.
       Compiling Cookbooks...
       Converging 0 resources
       [2014-03-21T16:07:53+00:00] INFO: Chef Run complete in 0.003989641 seconds
       [2014-03-21T16:07:53+00:00] INFO: Running report handlers
       [2014-03-21T16:07:53+00:00] INFO: Report handlers complete
       Chef Client finished, 0 resources updated
       Finished converging <default-ubuntu-1204> (0m3.14s).
-----> Setting up <default-ubuntu-1204>...
       Finished setting up <default-ubuntu-1204> (0m0.00s).
-----> Verifying <default-ubuntu-1204>...
       Finished verifying <default-ubuntu-1204> (0m0.00s).
-----> Destroying <default-ubuntu-1204>...
       [default] Forcing shutdown of container...
       [default] Destroying VM and associated drives...
       Vagrant instance <default-ubuntu-1204> destroyed.
       Finished destroying <default-ubuntu-1204> (0m9.67s).
       Finished testing <default-ubuntu-1204> (0m40.21s).
-----> Kitchen is finished. (0m41.00s)
```

Ok, everything is in place and working. Time to write some tests :-)

I'll keep going at the [webtest-1][2] step.


  [1]: https://github.com/fgrehm/vagrant-lxc
  [2]: ../webtest-1
