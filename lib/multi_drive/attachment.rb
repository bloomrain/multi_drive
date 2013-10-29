module MultiDrive::Attachment
  def has_multi_drive_attached_file(attachment_name, options = {})
    has_attached_file attachment_name, options

    serialize :multiple_drive_storage

    define_method "#{attachment_name}_url" do |style = :original|
      public_send(attachment_name).url(style)
    end

    define_method :upload_to_storage! do |*styles|
      attachment = public_send(attachment_name)
      styles = attachment.styles.keys + [:original] if styles.blank?
      storage_data = {}
      if public_send("#{attachment_name}?")
        attachment_file_name = public_send("#{attachment_name}_file_name")
        api_client = multi_drive_client.random
        styles.each do |attachment_style|
          destination_path = attachment.url(attachment_style, false)
          destination_path = destination_path[0, destination_path.length - attachment_file_name.length]
          file_path = attachment.path(attachment_style)
          storage_data[attachment_style.to_sym] = {
            local: {
              path: destination_path,
              file_name: attachment_file_name
            },
            api: {
              name: api_client.name,
              path: destination_path,
              file_name: attachment_file_name,
              uploaded_at: Time.now
            }
          }
          api_client.upload_file(file_path, destination_path)
          File.delete(attachment.path(attachment_style))
        end

        update_attributes!(multi_drive_storage: storage_data)
      else
        throw Exception.new("No attachment to upload")
      end
    end

    define_method :download_from_storage! do |style|
      fake_attachment = OpenStruct.new(filename: multi_drive_filename, original_filename: multi_drive_filename, instance: self, name: attachment.name)
      attachment = public_send(attachment_name)
      attachment_options = attachement.instance_variable_get('@options')
      url_generator = attachement.instance_variable_get('@url_generator')

      path = url_generator.new(fake_attachment, attachment_options).for(style, {timestamp: false, escape: true})

      api_client = multi_drive_client.client(multi_drive_storage)
      self.attachment = File.new( api_client.download_file(path) )
      save!
    end

    define_method :multi_drive_client do
      @multi_drive_client ||= MultiDrive::Client.new
    end
  end
end