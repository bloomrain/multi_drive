require 'multi_drive/api_client'
class MultiDrive::MegaClient < MultiDrive::ApiClient
  attr_accessor :api, :config, :name, :api_key, :client_secret, :access_token

  def upload_file(file, destination_path)
    file_path = file.is_a?(File) ? file.path : file
    current_folder = folder_at(destination_path, create_if_not_found: true)
    current_folder.upload(file_path)
  end

  def download_file(file_path)
    destination_path = file_path.split('/')
    file_name = destination_path.pop
    file_folder = folder_at destination_path.join('/')
    file_folder.files.detect{|file| file.name == file_name}.download
  end

  def delete_file(file_path)
    client.file(file_path).delete
  end

  def folder_at(path, options = {})
    folder = client.root
    path.split("/").select(&:present?).each do |folder_name|
      p folder.name
      new_folder = folder.folders.detect{|fld| fld.name == folder_name}
      p new_folder.try(:name)
      p "folder name: #{folder_name}"
      if new_folder.nil? and options[:create_if_not_found] == true
        new_folder ||= folder.create_folder(folder_name)
        p "after folder create..: #{new_folder.inspect}"
      end
      break if new_folder.nil?
      folder = new_folder
    end
    folder
  end

  private

  def client
    @client ||= begin
      require 'rmega'
      Rmega.login(login, password)
    end
  end
end
