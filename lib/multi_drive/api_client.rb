class MultiDrive::ApiClient
  attr_accessor :api, :config, :name, :api_key, :client_secret, :access_token

  def initialize(config)
    self.config = config.clone.with_indifferent_access
    self.api = self.config[:api]
    self.name = self.config[:name] || api
    self.api_key = self.config[:api_key]
    self.client_secret = self.config[:client_secret]
    self.access_token = self.config[:access_token]
  end

  def upload_file(file, destination_path)
    raise Exception.new('Not implemented')
  end

  def download_file(file_path)
    raise Exception.new('Not implemented')
  end

  def delete_file(file_path)
    raise Exception.new('Not implemented')
  end

  private
end