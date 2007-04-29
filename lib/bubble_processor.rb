require 'RMagick'

#module Technoweenie
  #module AttachmentFu
    #module Processors
      
      module BubbleProcessor
        def self.included(base)
          base.send :extend, ClassMethods
          base.alias_method_chain :process_attachment, :processing
        end

        module ClassMethods
          # Yields a block containing an RMagick Image for the given binary data.
          def with_image(file, &block)
            begin
              binary_data = file.is_a?(Magick::Image) ? file : Magick::Image.read(file).first unless !Object.const_defined?(:Magick)
            rescue
              # Log the failure to load the image.  This should match ::Magick::ImageMagickError
              # but that would cause acts_as_attachment to require rmagick.
              logger.debug("Exception working with image: #{$!}")
              binary_data = nil
            end
            block.call binary_data if block && binary_data
          ensure
            !binary_data.nil?
          end
        end

        protected
        def process_attachment_with_processing
          return unless process_attachment_without_processing
          with_image do |img|
            resize_image_or_thumbnail! img
            self.width  = img.columns if respond_to?(:width)
            self.height = img.rows    if respond_to?(:height)
            callback_with_args :after_resize, img
          end if image?
        end

        # Performs the actual resizing operation for a thumbnail
        def resize_image(img, size)
          size = size.first if size.is_a?(Array) && size.length == 1 && !size.first.is_a?(Fixnum)
          
          if size.is_a?(Fixnum) || (size.is_a?(Array) && size.first.is_a?(Fixnum))
            logger.debug("size: #{size.class}")
            
            size = [size, size] if size.is_a?(Fixnum)
            size = [size.first,size.first] if size.is_a?(Array) and size.length == 1
            
            img.crop_resized!(*size)
            
            mask = Magick::Image.new(48,48) { self.background_color = 'black' }
            gc = Magick::Draw.new
            gc.fill_color('white')
            gc.roundrectangle(0,0,48,48,10,10)
            gc.draw(mask)

            mask.matte = false
            img.matte = true
            img.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
            self.temp_path = write_to_temp_file(img.to_blob { self.format = 'PNG' })
          else
            img.change_geometry(size.to_s) { |cols, rows, image| image.resize!(cols, rows) }
            self.temp_path = write_to_temp_file(img.to_blob)
          end
          

        end
      end
      
    #end
  #end
#end