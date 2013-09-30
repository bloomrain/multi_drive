class MultiDrive::InnerClient
  attr_accessor :client, :api, :primary_options

  def initialize(api, options)
    self.client = box_client if api.to_sym == :box
    self.api = api
    self.config = options.clone
  end

  def box_client
    @box_client ||= begin
      require 'ruby-box'
      session = RubyBox::Session.new({
        client_id: config[:box][:client_id],
        client_secret: config[:box][:client_secret],
        access_token: config[:box][:access_token]
      })

      RubyBox::Client.new(session)
    end
  end

  def upload_file(file, destination_path)
    file_path = file.is_a?(File) ? file.path : file
    shared_link = box_client.upload_file(file_path, destination_path).create_shared_link
    shared_link.url
  end
end