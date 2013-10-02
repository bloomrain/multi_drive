require 'ruby-box'

class MultiDrive::BoxClient
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
    file_path = file.is_a?(File) ? file.path : file
    client.upload_file(file_path, destination_path)
  end

  def download_file(file_path)
    client.file(file_path).download
  end

  def delete_file(file_path)
    client.file(file_path).delete
  end

  private

  def client
    @client ||= begin
      require 'ruby-box'
      session = RubyBox::Session.new({
         client_id: api_key,
         client_secret: client_secret,
         access_token: access_token
      })

      RubyBox::Client.new(session)
    end
  end
end