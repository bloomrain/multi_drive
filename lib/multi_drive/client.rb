require 'multi_drive/box_client'
require 'multi_drive/skydrive_client'
require 'multi_drive/mega_client'

class MultiDrive::Client
  attr_accessor :available_clients, :current_client

  def initialize(config = Rails.root.join('config', 'multi_drive.yml').to_s)
    if config.is_a?(String)
      config = YAML.load( File.open(config) )
    end

    config = config.clone.with_indifferent_access
    self.available_clients = {}
    config[:storages].each do |options|
      api = options[:api]
      client_name = options[:name] || api
      self.available_clients[client_name] ||= "MultiDrive::#{api.camelize}Client".constantize.new(options)
    end
  end

  def random
    @current_client = available_clients.values.sample
  end

  def use(client_name)
    @current_client = available_clients[client_name]
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