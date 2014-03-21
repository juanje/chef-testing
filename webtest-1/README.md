# Webtest: 0

# Goal

This time the goal will be more interesting, it will be my *business goal*, to have a web page with my welcome to the world.

In other words:
> I want to have a web page that says '**Hello world!**'.

The very first thing I'm going to do to archive that goal is to describe that goal as a test that I can check against my *server*. And for that I'll use **ServerSpec** in combination with **Test-Kitchen**.

At the earlier step I left ready all the needed environment to test it, now just rest to write the actual tests.

Here is the new structure for my project. Basicaly the same plus the subtree `tests`:
```
webtest-1/
├── Gemfile
├── Gemfile.lock
├── .gitignore
├── .kitchen.yml
├── metadata.rb
├── README.md
├── recipes
│   └── default.rb
└── test
    └── integration
        └── default
            └── serverspec
                ├── localhost
                │   └── webtest_spec.rb
                └── spec_helper.rb
```

The structure of the tests for ServerSpec in Test-Kitchen is:
**test** -> **integration** -> **[name of the suit]** -> **serverspec** -> **localhost** -> **tests**


## My business goal as a test

I know where to put the test and what my business goal is, now is time to define it as specification or test.

It could be something like this:
```
describe "Web server" do
  let(:host) { URI.parse('http://localhost') }

  it "is showing a page with the text 'Hello world'" do
    connection = Faraday.new host
    page = connection.get('/').body

    expect(page).to match /Hello world/
  end

end
```

As the test will be ran inside the system I want to test, I''l define the host where I'd like to see the web page as `localhost`.

This test will try for me to connect to the host as if it were a web browser and check if it shows a page with the text **Hello world!**.

Which is exactly what I want to have from the business point of view :-)

## Testing and fail

In the testing business, the first step is to have a test that fails, otherwise you don't really know if it was your code who made the test pass.

So I wrote the test (see the files) and I run:
```
$ bundle exec kitchen test
```
**Note:** Actually I had an issue writing the test because something I explain [here][1].

And I got this failing output:
```
-----> Starting Kitchen (v1.2.1)
-----> Cleaning up any prior instances of <default-ubuntu-1204>
-----> Destroying <default-ubuntu-1204>...
       [default] Forcing shutdown of container...
       [default] Destroying VM and associated drives...
       Vagrant instance <default-ubuntu-1204> destroyed.
       Finished destroying <default-ubuntu-1204> (0m8.76s).
-----> Testing <default-ubuntu-1204>
-----> Creating <default-ubuntu-1204>...
       Bringing machine 'default' up with 'lxc' provider...
[default] Importing base box 'ubuntu-12.04-i386'...       [Berkshelf] Skipping Berkshelf with --no-provision
       [default] Setting up mount entries for shared folders...
[default] Starting container...[default] Waiting for machine to boot. This may take a few minutes...       [default] Machine booted and ready!
       [default] Setting hostname...
       Vagrant instance <default-ubuntu-1204> created.
       Finished creating <default-ubuntu-1204> (0m28.66s).
-----> Converging <default-ubuntu-1204>...
       Preparing files for transfer
       Preparing current project directory as a cookbook
       Removing non-cookbook files before transfer
       Transfering files to <default-ubuntu-1204>
       [2014-03-21T16:40:50+00:00] INFO: Forking chef instance to converge...
Starting Chef Client, version 11.6.0
[2014-03-21T16:40:50+00:00] INFO: *** Chef 11.6.0 ***
       [2014-03-21T16:40:51+00:00] INFO: Setting the run_list to ["recipe[webtest::default]"] from JSON
       [2014-03-21T16:40:51+00:00] INFO: Run List is [recipe[webtest::default]]
       [2014-03-21T16:40:51+00:00] INFO: Run List expands to [webtest::default]
       [2014-03-21T16:40:51+00:00] INFO: Starting Chef Run for default-ubuntu-1204
       [2014-03-21T16:40:51+00:00] INFO: Running start handlers
       [2014-03-21T16:40:51+00:00] INFO: Start handlers complete.
       Compiling Cookbooks...
       Converging 0 resources
       [2014-03-21T16:40:51+00:00] INFO: Chef Run complete in 0.003876696 seconds
       [2014-03-21T16:40:51+00:00] INFO: Running report handlers
       [2014-03-21T16:40:51+00:00] INFO: Report handlers complete
       Chef Client finished, 0 resources updated
       Finished converging <default-ubuntu-1204> (0m3.11s).
-----> Setting up <default-ubuntu-1204>...
Fetching: thor-0.18.1.gem (100%)
Fetching: busser-0.6.0.gem (100%)
       Successfully installed thor-0.18.1
       Successfully installed busser-0.6.0
       2 gems installed
-----> Setting up Busser
       Creating BUSSER_ROOT in /tmp/busser
       Creating busser binstub
       Plugin serverspec installed (version 0.2.6)
-----> Running postinstall for serverspec plugin
       Finished setting up <default-ubuntu-1204> (0m38.67s).
-----> Verifying <default-ubuntu-1204>...
       Suite path directory /tmp/busser/suites does not exist, skipping.
       Uploading /tmp/busser/suites/serverspec/localhost/webtest_spec.rb (mode=0664)
       Uploading /tmp/busser/suites/serverspec/spec_helper.rb (mode=0664)
-----> Running serverspec test suite
       /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -S /tmp/busser/gems/bin/rspec /tmp/busser/suites/serverspec/localhost/webtest_spec.rb --color --format documentation
Fetching: multipart-post-2.0.0.gem (100%)
Fetching: faraday-0.9.0.gem (100%)

       Web server
         is showing a page with the text 'Hello world' (FAILED - 1)

       Failures:

         1) Web server is showing a page with the text 'Hello world'
            Failure/Error: page = connection.get('/').body
            Faraday::ConnectionFailed: Connection refused - connect(2)

       Connection refused - connect(2)
            # /tmp/busser/suites/serverspec/localhost/webtest_spec.rb:8:in `block (2 levels) in <top (required)>'

       Finished in 0.18644 seconds

       1 example, 1 failure

       Failed examples:

rspec /tmp/busser/suites/serverspec/localhost/webtest_spec.rb:6 # Web server is showing a page with the text 'Hello world'
       /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -S /tmp/busser/gems/bin/rspec /tmp/busser/suites/serverspec/localhost/webtest_spec.rb --color --format documentation failed
       Ruby Script[/tmp/busser/gems/gems/busser-serverspec-0.2.6/lib/busser/runner_plugin/../serverspec/runner.rb /tmp/busser/suites/serverspec] exit code was 1
>>>>>> Verify failed on instance <default-ubuntu-1204>.
>>>>>> Please see .kitchen/logs/default-ubuntu-1204.log for more details
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: SSH exited (1) for command: [sh -c 'BUSSER_ROOT="/tmp/busser" GEM_HOME="/tmp/busser/gems" GEM_PATH="/tmp/busser/gems" GEM_CACHE="/tmp/busser/gems/cache" ; export BUSSER_ROOT GEM_HOME GEM_PATH GEM_CACHE; sudo -E /tmp/busser/bin/busser test']
>>>>>> ----------------------
```

It's actually what I was looking for, a test that my expectation failing because I didn't do anything yet to make it work.

Next step is to define my technical approach to this business goal and write some test for that approach.

I'll continue with that on the [next step][2] :-)



  [1]: https://gist.github.com/juanje/9603938
  [2]: ../webtest-2
