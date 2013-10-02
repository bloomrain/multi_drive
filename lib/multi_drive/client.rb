require 'multi_drive/box_client'

class MultiDrive::Client
  attr_accessor :clients

  def initialize(config = Rails.root.join('config', 'multi_drive.yml').to_s)
    if config.is_a?(String)
      config = YAML.load( File.open(config) )
    end

    config = config.clone.with_indifferent_access
    self.clients = {}
    config[:storages].each do |options|
      api = options[:api]
      client_name = options[:name] || api
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