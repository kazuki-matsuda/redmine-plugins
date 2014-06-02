# -*- coding: utf-8 -*-

# Jobがない場合の例外
class HudsonNoJobException < Exception
end

# 設定がない場合の例外
class HudsonNoSettingsException < Exception
end

class HudsonApiException < Exception
  unloadable

  include ApplicationHelper
  include ActionView::Helpers::TextHelper
  include I18n
  
  attr_reader :message, :code, :inner_exception

  def initialize( object )
    @code = ""
    @message = ""
    @inner_exception = object

    case object
    when Net::HTTPResponse
      @code = object.code
      @message = I18n.t :notice_err_http_error, :code => object.code, :message => object.message

    when Net::HTTPBadResponse
      @message = I18n.t :notice_err_response_invalid, :description => "Net::HTTPBadResponse"
    when SocketError
      @message = I18n.t :notice_err_cant_connect, :description => object.message
    
    when Errno::ECONNREFUSED, Errno::ETIMEDOUT
      @message = I18n.t :notice_err_cant_connect, :description => object.message
    
    when URI::InvalidURIError
      @message = I18n.t :notice_err_invalid_url
    
    when REXML::ParseException
      @message = I18n.t :notice_err_response_invalid, :description => truncate(object.to_s, :length => 100)
    
    else
      # ruby1.8.7 returns error - "undefined method `closed?' for nil:NilClass" when can't connect server ???
      if "undefined method `closed?' for nil:NilClass" == object.message
        @message = I18n.t :notice_err_cant_connect, :description => object.message
      else
        @message = I18n.t :notice_err_unknown, :description => truncate(object.message, :length => 100)
      end
    end
  end

  def to_s
    base = super
    "#{base} message:#{@message} code:#{@code} inner exception:#{@inner_exception.to_s}"
  end
  
end
