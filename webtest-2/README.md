# Webtest: 0

# Goal

Ok, I have defined the business goal as:

> I want to have a web page that says '**Hello world!**'.

And a test to check that my code will acomplish that:

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

Now I need to define the technical approach. The simplest one could be:

> To have a **web server** that will serve a **html file** with the content **Hello world!**.

## My technical approach as a test

I'll use **ChefSpec** for this kind of test because are becoming *the way to go* in the Chef world and are quite fast.
Also the *rspec* syntax make it very familiar and easy to write.

To have a web server serving a html file I will need to install the web server, put the html file in some place where the web server can serve it and be sure the web server is running and serving it. So:

* Install a web server
* Put a html file some place accessible for the webserver
* Make sure the web server is running and serving that file

Well, let's put this as a tests:

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

## Testing and fail

Before I try the test I need to add **ChefSpec** to the Ruby dependencies, so we can use it. Let's change the `Gemfile` by adding `gem 'chefspec'`:

```
source 'https://rubygems.org'

gem 'test-kitchen'
gem 'kitchen-vagrant'
gem 'busser-serverspec'
gem 'chefspec'
```
Now let's update the dependencies:
```
$ bundle update
```

Now we can run the tests and see how they fail:
```
$ bundle exec rspec -cfd spec/unit/recipes/default_spec.rb
```

The failing output:
```
webtest::default
  install nginx package (FAILED - 1)
  enable nginx service (FAILED - 2)
  start nginx service (FAILED - 3)
  server a web page that says "Hello world!" (FAILED - 4)

Failures:

  1) webtest::default install nginx package
     Failure/Error: let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
     Chef::Exceptions::CookbookNotFound:
       Cookbook nginx not found. If you're loading nginx from another cookbook, make sure you configure the dependency in your metadata
     # ./spec/unit/recipes/default_spec.rb:4:in `block (2 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:7:in `block (2 levels) in <top (required)>'

  2) webtest::default enable nginx service
     Failure/Error: let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
     Chef::Exceptions::CookbookNotFound:
       Cookbook nginx not found. If you're loading nginx from another cookbook, make sure you configure the dependency in your metadata
     # ./spec/unit/recipes/default_spec.rb:4:in `block (2 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:11:in `block (2 levels) in <top (required)>'

  3) webtest::default start nginx service
     Failure/Error: let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
     Chef::Exceptions::CookbookNotFound:
       Cookbook nginx not found. If you're loading nginx from another cookbook, make sure you configure the dependency in your metadata
     # ./spec/unit/recipes/default_spec.rb:4:in `block (2 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:15:in `block (2 levels) in <top (required)>'

  4) webtest::default server a web page that says "Hello world!"
     Failure/Error: let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
     Chef::Exceptions::CookbookNotFound:
       Cookbook nginx not found. If you're loading nginx from another cookbook, make sure you configure the dependency in your metadata
     # ./spec/unit/recipes/default_spec.rb:4:in `block (2 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:19:in `block (2 levels) in <top (required)>'

Finished in 0.04371 seconds
4 examples, 4 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:6 # webtest::default install nginx package
rspec ./spec/unit/recipes/default_spec.rb:10 # webtest::default enable nginx service
rspec ./spec/unit/recipes/default_spec.rb:14 # webtest::default start nginx service
rspec ./spec/unit/recipes/default_spec.rb:18 # webtest::default server a web page that says "Hello world!"
```


Great! Now we have or technical specifications and a way to proof them :-)

The next is to write some code to implement these specifications. But that is the [next step][1]

  [1]: ../webtest-3
