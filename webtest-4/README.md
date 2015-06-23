# Webtest: 4

# Goal

**WIP**: This is just the skeleton to write the documentation for this step.

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


### What next?
Now we'll do the same for the last test and the next step after all the unit test have passed will be to check the integration tests.

We'll see that is the [next step][1]

  [1]: ../webtest-5
