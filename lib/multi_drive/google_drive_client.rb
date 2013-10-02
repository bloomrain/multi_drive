
class MultiDrive::GoogleDriveClient < ApiClient
  def upload_file(file, destination_path)
    file_path = file.is_a?(File) ? file.path : file
    client.upload_from_file(file_path, destination_path, convert: false)
  end

  def download_file(file_path)
    file = client.file_by_title(file_path)
    file(file_path).download_to_string
  end

  private

  def client
    @client ||= begin
      require 'google_drive'
      GoogleDrive.login_with_oauth(access_token)
    end
  end
end