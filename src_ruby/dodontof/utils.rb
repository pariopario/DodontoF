#--*-coding:utf-8-*--

require 'cgi'
require 'json/jsonParser'

require 'dodontof/logger'

module DodontoF
  # ユーティリティメソッドを格納するモジュール
  module Utils
    # オブジェクトを JSON で表現した文字列を返す
    # @param [Object] obj JSON に変換するオブジェクト
    # @return [String]
    def getJsonString(obj)
      JsonBuilder.new.build(obj)
    end
    module_function :getJsonString

    # JSON 文字列からオブジェクトに変換する
    # @param [String] jsonString JSON 文字列
    # @return [Array, Hash, nil]
    def getObjectFromJsonString(jsonString)
      logger = DodontoF::Logger.instance

      logger.debug(jsonString, 'getObjectFromJsonString start')
      begin
        begin
          # 文字列の変換なしでパースを行ってみる
          parsed = JsonParser.new.parse(jsonString)
          logger.debug('getObjectFromJsonString parse end')

          return parsed
        rescue => e
          # エスケープされた文字を戻してパースを行う
          parsedWithUnescaping = JsonParser.new.parse(CGI.unescape(jsonString))
          logger.debug('getObjectFromJsonString parse with unescaping end')

          return parsedWithUnescaping
        end
      rescue => e
        # logger.exception(e)
        return {}
      end
    end
    module_function :getObjectFromJsonString
  end
end