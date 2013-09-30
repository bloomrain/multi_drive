class MultiDrive::Client
  attr_accessor :clients

  def initialize(config)
    self.clients = {}
    config.each_pair do |api, options|
      client_name = options[:name] || api
      self.clients[client_name] ||= MultiDrive::ApiClient.new(:api, options)
    end
  end

  def random_client
    clients.values.sample
  end

  def upload_file(file, destination_path)
    file_path = file.is_a?(File) ? file.path : file
    shared_link = random_client.upload_file(file_path, destination_path).create_shared_link
    shared_link.url
  end
end