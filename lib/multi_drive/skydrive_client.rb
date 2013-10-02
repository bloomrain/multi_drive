require 'multi_drive/api_client'
class MultiDrive::SkydriveClient < MultiDrive::ApiClient
  attr_accessor :api, :config, :name, :api_key, :client_secret, :access_token, :access_token_object

  def upload_file(file, destination_path)

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
      require 'skydrive'
      oauth_client = Skydrive::Oauth::Client.new(client_id, client_secret, "http://aaadddsfdsdfasfhgf.com", "wl.skydrive_update,wl.offline_access")
      self.access_token_object = OAuth2::AccessToken.new(oauth_client, access_token, {:refresh_token => refresh_token, :expires_at => 1.hour.since(Time.now).to_i})
      Skydrive::Client.new(access_token_object)
    end
  end
end