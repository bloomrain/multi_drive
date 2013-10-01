class MultiDrive::BoxClient
  attr_accessor :api, :primary_options

  def initialize(config)
    self.api = :box
    self.config = config.clone
    self.name = config[:name] || api
  end

  def upload_file(file, destination_path)
    file_path = file.is_a?(File) ? file.path : file
    shared_link = client.upload_file(file_path, destination_path).create_shared_link
    shared_link.url
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
         client_id: config[:box][:client_id],
         client_secret: config[:box][:client_secret],
         access_token: config[:box][:access_token]
      })

      RubyBox::Client.new(session)
    end
  end
end