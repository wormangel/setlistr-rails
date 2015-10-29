CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',                        # required
    aws_access_key_id: ENV['SETLISTR_S3_ACCESS_KEY'],                        # required
    aws_secret_access_key: ENV['SETLISTR_S3_SECRET_KEY'],
    endpoint: 'http://s3-sa-east-1.amazonaws.com',
    region: 'sa-east-1'
  }
  config.fog_directory  = ENV['SETLISTR_S3_BUCKET']                          # required
end