class MultiDrive::Client
  attr_accessor :clients

  def initialize(config)
    self.clients = {}
    config[:credentials].each do |options|
      client_name = options[:name] || options[:api]
      self.clients[client_name] ||= "MultiDrive::#{api.camelize}Client".constantize.new(options)
    end
  end

  def random
    clients.values.sample
  end

  def client(name)
    @client_by_name ||= clients.group_by(&:name).with_indifferent_access
    @client_by_name[name]
  end

  def upload_file(file, destination_path)
    random.upload_file(file, destination_path)
  end

  def download_file(file_path)
    random.download_file(file_path)
  end

  def delete_file(file_path)
    random.delete_file(file_path)
  end

end