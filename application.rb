require 'aws/s3'

class Application < Rhoconnect::Base
  include AWS::S3

  class << self
    def authenticate(username,password,session)
      true # do some interesting authentication here...
    end
    
    def initializer(path)
      super
#      clean_amazon_storage
    end

    def clean_amazon_storage
	AWS::S3::Base.establish_connection!(
		:access_key_id		=> ENV['AMAZON_ACCESS_KEY_ID'],
		:secret_access_key	=> ENV['AMAZON_SECRET_ACCESS_KEY']
	)

#	AWS::S3::Bucket.create('rhodes-store-bulk-blobs')
#	AWS::S3::Bucket.create('rhodes-store-bulk-blobs-scheme')	

#	bucket = 'rhodes-system-samples-images-auto'

	AWS::S3::Bucket.find('rhodes-store-bulk-blobs').objects.each do |entry|
		puts "Found: #{entry.inspect}"
		AWS::S3::S3Object.delete entry.key, 'rhodes-store-bulk-blobs'
	end

	AWS::S3::Bucket.find('rhodes-store-bulk-blobs-scheme').objects.each do |entry|
		puts "Found: #{entry.inspect}"
		AWS::S3::S3Object.delete entry.key, 'rhodes-store-bulk-blobs-scheme'
	end
    end

    def store_blob(obj,field_name,blob)
      puts "store_blob: obj=#{obj}, field_name=#{field_name}, blob=#{blob}"
      if blob
        obj['filename'] = blob[:filename]
        obj['image_uri'] = blob[:tempfile].path
      end
      super
    end
  end
end

Application.initializer(ROOT_PATH)
