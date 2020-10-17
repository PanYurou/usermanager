# frozen_string_literal: true

require 'Encryptor'
module TokenManager
  include Encryptor

  def generate_token(user_id, user_name, user_type)
    extime = Time.now.to_i + add_day(2)
    token = encrypt_string(user_id) + '.' + encrypt_string(user_name) + '.' +
        encrypt_string(user_type) + '.' + encrypt_string(extime.to_s)
    token
  end

  def decrypt_token(token)
    return false if token.nil? || token.empty?
    d = {}
    token.split('.').each_with_index do |item, index|
      case index
      when 0
        d[:user_id] = decrypt_string item
      when 1
        d[:user_name] = decrypt_string item
      when 2
        d[:user_type] = decrypt_string item
      when 3
        d[:token_ex] = decrypt_string item
      end
    end
    d
  end

  private

  def add_day(day = 1)
    86400 * day.to_i
  end

end