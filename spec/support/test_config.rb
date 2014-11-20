module TestConfig
  def riak_setup
    begin
      require 'yaml'
      status = `riak start`
      raise 'Cannot start riak' if !`riak ping`[/^pong/]
      config = YAML.load_file(File.expand_path("../test_config.yml", __FILE__))
    rescue => e
      pending("Can't run ripple integration specs without the test server. Specify the location of your Riak installation in spec/support/test_server.yml\n#{e.inspect}")
    end
  end

  def random_bucket(name='test_client')
    bucket_name = [name, Time.now.to_i, random_key].join('-')
    test_client.bucket bucket_name
  end

  def random_key
    rand(36**10).to_s(36)
  end

end

RSpec.configure do |config|
  config.include TestConfig, :integration => true
  config.filter_run_excluding no_index: true unless ENV['ALLOW_INDEXES']
  config.filter_run_excluding no_conflict: true unless ENV['ALLOW_CONFLICT']
  config.filter_run_excluding no_search: true unless ENV['ALLOW_CONFLICT']

  config.before(:each, :integration => true) do
    Ripple.config = {
      :server => riak_setup['host'],
      :http_port => riak_setup['http_port'],
      :pb_port => riak_setup['pb_port']
    }
  end

  config.after(:each, :integration => true) do
    #
  end

  config.before(:suite) do
  end

  config.after(:suite) do
    #
  end
end
