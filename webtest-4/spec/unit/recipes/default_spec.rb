require 'chefspec'

describe 'webtest-4::default' do
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
    expect(chef_run).to render_file('/var/www/index.html').with_content(/Hello world!.*/)
  end
end
