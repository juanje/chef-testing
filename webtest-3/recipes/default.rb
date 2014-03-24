package 'nginx'

service 'nginx' do
  action :enable
end

service 'nginx' do
  action :start
end
