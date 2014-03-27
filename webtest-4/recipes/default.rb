package 'nginx'

service 'nginx' do
  action [ :enable, :start ]
end

file '/var/www/index.html' do
  content 'Hello world!'
end
