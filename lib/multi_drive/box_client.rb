require 'multi_drive/api_client'
class MultiDrive::BoxClient < MultiDrive::ApiClient
  attr_accessor :api, :config, :name, :api_key, :client_secret, :access_token

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