require 'active_support/core_ext/hash/keys'
require 'active_support/inflector/methods'
require 'active_support/core_ext/object/blank'
require 'yaml'
require 'google/api_client'

module Paperclip

  module Storage
    # * self.extended(base) add instance variable to attachment on call
    # * url return url to show on site with style options
    # * path(style) return title that used to insert file to store or find it in store
    # * public_url_for title  return url to file if find by title or url to default image if set
    # * search_for_title(title) take title, search in given folder and if it finds a file, return id of a file or nil
    # * metadata_by_id(file_i get file metadata from store, used to back url or find out value of trashed
    # * exists?(style)  check either exists file with title or not
    # * default_image  return url to default url if set in option
    # * find_public_folder return id of Public folder, must be in options
    # return id of Public folder, must be in options
    # * file_tit return base pattern of title or custom one set by user
    # * parse_credentials(credenti get credentials from file, hash or path
    # * assert_required_keys  check either all ccredentials keys is set
    # * original_extension  return extension of file

    module MultiDrive

      def self.extended(base)
        attr_accessor :multi_drive_options

        base.instance_eval do
          self.multi_drive_options = parse_credentials(@options[:multi_drive] || {})
          @options[:dropbox_options] ||= {}
          @options[:dropbox_credentials] = fetch_credentials
          @options[:path] = nil if @options[:path] == self.class.default_options[:path]
          @path_generator = PathGenerator.new(self, @options)
          @url_generator = UrlGenerator.new(self, @options)
        end
      end

      def flush_writes
        @queued_for_write.each do |style, file|
          client.random.upload_file(file.read, path(style))
        end
        after_flush_writes
        @queued_for_write.clear
      end

      def client
        @client ||= begin
          config = parse_credentials(@options[:multi_drive] || {})
          MultiDrive::Client.new(config)
        end
      end



      def flush_deletes
        @queued_for_delete.each do |path|
          client.delete_file(path)
        end
        @queued_for_delete.clear
      end

      def url(style_or_options = default_style, options = {})
        options.merge!(style_or_options) if style_or_options.is_a?(Hash)
        style = style_or_options.is_a?(Hash) ? default_style : style_or_options
        @url_generator.generate(style, options)
      end

      def path(style = default_style)
        @path_generator.generate(style)
      end

      def copy_to_local_file(style = default_style, destination_path)
        File.open(destination_path, "wb") do |file|
          file.write(dropbox_client.get_file(path(style)))
        end
      end

      def exists?(style = default_style)
        return false if not present?
        metadata = dropbox_client.metadata(path(style))
        not metadata.nil? and not metadata["is_deleted"]
      rescue DropboxError
        false
      end

      private

      def fetch_credentials
        environment = defined?(Rails) ? Rails.env : @options[:dropbox_options][:environment]
        Credentials.new(@options[:dropbox_credentials]).fetch(environment)
      end

      class FileExists < RuntimeError
      end
    end
  end

end