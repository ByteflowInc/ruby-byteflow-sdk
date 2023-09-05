require 'faraday'
require 'faraday/retry'
require 'nanoid'

# $baseURL = "https://api.byteflow.app"
$baseURL = "http://localhost:8911"

class ByteflowSDK
  def initialize(apiKey)
    retry_options = {
      retry_statuses: [420],
      methods: %i[get post]
    }
    @conn = Faraday.new(
      url: $baseURL,
      headers: {'Content-Type' => 'application/json', "api_key" => apiKey }
    ) do |f|
      f.request :retry, retry_options
    end
  end
  def sendMessage(to,content)
    response = @conn.post('/sendMessage') do |req|
      req.body = {
        message_content: content,
        destination_number: to
      }.to_json
      req.headers["retry-id"] = Nanoid.generate
    end
    response
  end
  def registerNumber(phone_number)
    response = @conn.post('/registerNumber') do |req|
      req.body = {
        phone_number: phone_number
      }.to_json
    end
    response.body
  end
  def sendMessageWithMedia(file_path,to,content)
    # Generate URLs
    uploadMediaResponse = @conn.post('/uploadMedia') do |req|
      req.body = {
        filename: File.basename(file_path)
      }.to_json
    end
    parsedUploadMediaResponse = JSON.parse(uploadMediaResponse.body)
    getURL = parsedUploadMediaResponse["getURL"]
    uploadURL = parsedUploadMediaResponse["uploadURL"]
    # Upload file
    @conn.put(uploadURL,File.read(file_path))
    # Send Messages
    self.sendMessage(to,content + " " +getURL)
  end
  def lookupNumber(phone_number,advanced_mode)
    response = @conn.get("/lookupNumber?phone_number=#{phone_number}&advanced_mode=#{advanced_mode}")
    JSON.parse(response.body)
  end
end
