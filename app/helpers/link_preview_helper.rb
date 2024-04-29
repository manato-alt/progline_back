require 'metainspector'

module LinkPreviewHelper
  def fetch_metadata(url)
    if url.present?
      begin
        page = MetaInspector.new(url)
      
        title = page.title if page.title.present?
        description = page.description if page.description.present?
        image_url = page.images.best if page.images.best.present?
        favicon_url = page.images.favicon if page.images.favicon.present?
        
        { title: title,
          description: description,
          image_url: image_url,
          favicon_url: favicon_url,
          url: url }
      rescue StandardError => e
        Rails.logger.error "Error fetching metadata: #{e.message}"
        { title: 'Error', description: 'Failed to retrieve metadata', image_url: nil, favicon_url: nil }
      end
    end
  end
end