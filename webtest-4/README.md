# Webtest: 3

# Goal

Ok, I have defined the business goal as:

> I want to have a web page that says '**Hello world!**'.

Also how I think I going to accomplish that goal:
> * Install a web server
> * Put a html file some place accessible for the webserver
> * Make sure the web server is running and serving that file

And I have tests for both kind of goals:

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

```
describe 'webtest::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'install nginx package' do
    expect(chef_run).to install_package('nginx')
  end

  it 'enable nginx service' do
    expect(chef_run).to enable_service('nginx')
  end

  it 'start nginx service' do
    expect(chef_run).to start_service('nginx')
  end

  it 'server a web page that says "Hello world!"' do
    expect(chef_run).to render_file('/var/www/index.html').with_content(/Hello world!.+/)
  end
end
```

So the next logical step is to write some code (a Chef recipe in this case) to implement those specifications.

> **IMPORTANT NOTE:**
> As the `:chef_run` at the unit tests use the `described_recipe` to look for the recipe to test, **you must be sure that the recipe's name is correct**.
> Actually, **ChefSpec** looks for the recipe using the name of the directory as a name of the cookbook, not the name defined at the `metadata.rb` file.
>
> For example, I left the recipe's name as you see above in the tests, but as I was duplicating the project directory to show better the steps, **ChefSpec** wasn't looking at this version of the cookbook (`webtest-3`), but the one at the directory `webtest`.
>
> So I had to change the line:
> ```
> describe 'webtest::default' do
> ```
> to
> ```
> describe 'webtest-3::default' do
> ```

## Write code to pass the tests

### First iteration

#### Step 1: create the simplest recipe to pass the first unit test

```ruby
# recipes/default.rb

package 'nginx'
```

#### Step 2: check the tests

Run the tests:
```
$ bundle exec rspec -cfd spec/unit/recipes/default_spec.rb
```

Output:
```
webtest-3::default
  install nginx package
  enable nginx service (FAILED - 1)
  start nginx service (FAILED - 2)
  server a web page that says "Hello world!" (FAILED - 3)

Failures:

  1) webtest-3::default enable nginx service
     Failure/Error: expect(chef_run).to enable_service('nginx')
       expected "service[nginx]" with action :enable to be in Chef run. Other service resources:
       
         
        
     # ./spec/unit/recipes/default_spec.rb:11:in `block (2 levels) in <top (required)>'

  2) webtest-3::default start nginx service
     Failure/Error: expect(chef_run).to start_service('nginx')
       expected "service[nginx]" with action :start to be in Chef run. Other service resources:
       
         
        
     # ./spec/unit/recipes/default_spec.rb:15:in `block (2 levels) in <top (required)>'

  3) webtest-3::default server a web page that says "Hello world!"
     Failure/Error: expect(chef_run).to render_file('/var/www/index.html').with_content(/Hello world!.+/)
       expected Chef run to render "/var/www/index.html" matching:
       
       (?-mix:Hello world!.+)
       
       but got:
       
       
        
     # ./spec/unit/recipes/default_spec.rb:19:in `block (2 levels) in <top (required)>'

Finished in 0.31837 seconds
4 examples, 3 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:10 # webtest-3::default enable nginx service
rspec ./spec/unit/recipes/default_spec.rb:14 # webtest-3::default start nginx service
rspec ./spec/unit/recipes/default_spec.rb:18 # webtest-3::default server a web page that says "Hello world!"
```

Great! One has passed, three to go :-)

### Second iteration

#### Step 1: create the simplest recipe to pass the second unit test

Add these lines to the recipe to enable the service `Nginx` (the second specification):

```ruby
service 'nginx' do
  action :enable
end
```

#### Step 2: check the tests

Run the tests:
```
$ bundle exec rspec -cfd spec/unit/recipes/default_spec.rb
```

Output:
```
webtest-3::default
  install nginx package
  enable nginx service
  start nginx service (FAILED - 1)
  server a web page that says "Hello world!" (FAILED - 2)

Failures:

  1) webtest-3::default start nginx service
     Failure/Error: expect(chef_run).to start_service('nginx')
       expected "service[nginx]" actions [:enable] to include :start
     # ./spec/unit/recipes/default_spec.rb:15:in `block (2 levels) in <top (required)>'

  2) webtest-3::default server a web page that says "Hello world!"
     Failure/Error: expect(chef_run).to render_file('/var/www/index.html').with_content(/Hello world!.+/)
       expected Chef run to render "/var/www/index.html" matching:
       
       (?-mix:Hello world!.+)
       
       but got:
       
       
        
     # ./spec/unit/recipes/default_spec.rb:19:in `block (2 levels) in <top (required)>'

Finished in 0.05749 seconds
4 examples, 2 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:14 # webtest-3::default start nginx service
rspec ./spec/unit/recipes/default_spec.rb:18 # webtest-3::default server a web page that says "Hello world!"
```

### Second iteration

#### Step 1: create the simplest recipe to pass the second unit test

Add these lines to the recipe to start the service `Nginx` (the second specification), so the recipe now looks like this:

```ruby
package 'nginx'

service 'nginx' do
  action :enable
end

service 'nginx' do
  action :start
end
```

You'll probably see a better way to do it, but remember that it's not the time to optimize or look for the better implementation, but for he simplest one to pass the test.
This is part of the TDD process. We feel a bit silly at the beginning, but it will pay off later.

#### Step 2: check the tests

Run the tests:
```
$ bundle exec rspec -cfd spec/unit/recipes/default_spec.rb
```

Output:
```
webtest-3::default
[2014-03-24T17:08:08+00:00] WARN: Cloning resource attributes for service[nginx] from prior resource (CHEF-3694)
[2014-03-24T17:08:08+00:00] WARN: Previous service[nginx]: /home/jojeda/workspace/chef-testing/webtest-3/recipes/default.rb:3:in `from_file'
[2014-03-24T17:08:08+00:00] WARN: Current  service[nginx]: /home/jojeda/workspace/chef-testing/webtest-3/recipes/default.rb:7:in `from_file'
  install nginx package
[2014-03-24T17:08:08+00:00] WARN: Cloning resource attributes for service[nginx] from prior resource (CHEF-3694)
[2014-03-24T17:08:08+00:00] WARN: Previous service[nginx]: /home/jojeda/workspace/chef-testing/webtest-3/recipes/default.rb:3:in `from_file'
[2014-03-24T17:08:08+00:00] WARN: Current  service[nginx]: /home/jojeda/workspace/chef-testing/webtest-3/recipes/default.rb:7:in `from_file'
  enable nginx service
[2014-03-24T17:08:08+00:00] WARN: Cloning resource attributes for service[nginx] from prior resource (CHEF-3694)
[2014-03-24T17:08:08+00:00] WARN: Previous service[nginx]: /home/jojeda/workspace/chef-testing/webtest-3/recipes/default.rb:3:in `from_file'
[2014-03-24T17:08:08+00:00] WARN: Current  service[nginx]: /home/jojeda/workspace/chef-testing/webtest-3/recipes/default.rb:7:in `from_file'
  start nginx service
[2014-03-24T17:08:08+00:00] WARN: Cloning resource attributes for service[nginx] from prior resource (CHEF-3694)
[2014-03-24T17:08:08+00:00] WARN: Previous service[nginx]: /home/jojeda/workspace/chef-testing/webtest-3/recipes/default.rb:3:in `from_file'
[2014-03-24T17:08:08+00:00] WARN: Current  service[nginx]: /home/jojeda/workspace/chef-testing/webtest-3/recipes/default.rb:7:in `from_file'
  server a web page that says "Hello world!" (FAILED - 1)

Failures:

  1) webtest-3::default server a web page that says "Hello world!"
     Failure/Error: expect(chef_run).to render_file('/var/www/index.html').with_content(/Hello world!.+/)
       expected Chef run to render "/var/www/index.html" matching:
       
       (?-mix:Hello world!.+)
       
       but got:
       
       
        
     # ./spec/unit/recipes/default_spec.rb:19:in `block (2 levels) in <top (required)>'

Finished in 0.06043 seconds
4 examples, 1 failure

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:18 # webtest-3::default server a web page that says "Hello world!"

```

It pass! :-)
But it shows us some warnings about resources duplication. It's actually a good help for the next step: **the refactoring**.

#### Step 3: Refactor the recipe

Let's refactor a bit our recipe and make it looks like this:
```ruby
package 'nginx'

service 'nginx' do
  action [ :enable, :start ]
end
```

#### Step 4: check the tests

Run again the tests:
```
$ bundle exec rspec -cfd spec/unit/recipes/default_spec.rb
```

Output:
```
webtest-3::default
  install nginx package
  enable nginx service
  start nginx service
  server a web page that says "Hello world!" (FAILED - 1)

Failures:

  1) webtest-3::default server a web page that says "Hello world!"
     Failure/Error: expect(chef_run).to render_file('/var/www/index.html').with_content(/Hello world!.+/)
       expected Chef run to render "/var/www/index.html" matching:
       
       (?-mix:Hello world!.+)
       
       but got:
       
       
        
     # ./spec/unit/recipes/default_spec.rb:19:in `block (2 levels) in <top (required)>'

Finished in 0.0578 seconds
4 examples, 1 failure

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:18 # webtest-3::default server a web page that says "Hello world!"

```

It still pass the three test and it has much nicer output :-)


### What next?
Now we'll do the same for the last test and the next step after all the unit test have passed will be to check the integration tests.

We'll see that is the [next step][1]

  [1]: ../webtest-4
