class ProfileImageUploader < CarrierWave::Uploader::Base
  # リサイズしたり画像形式を変更するのに必要
  include CarrierWave::RMagick

  # 画像の上限を200pxにする
  MAX_WIDTH = 300
  MAX_HEIGHT = 300
  process resize_to_limit: [MAX_WIDTH, MAX_HEIGHT]

  # 保存形式をJPGにする
  process convert: 'jpg'

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # jpg,jpeg,pngしか受け付けない
  def extension_white_list
    %w(jpg jpeg png)
  end

  # 拡張子が同じでないとGIFをJPGとかにコンバートできないので、ファイル名を変更
  def filename
    super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
  end
end
