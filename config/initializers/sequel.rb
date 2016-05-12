# Source https://gist.github.com/citrus/1602209
module Kaminari
  module Sequel

    def self.included(base)

      #base.class_eval do
        #alias :num_pages :page_count
        #alias :limit_value :page_size
      #end

      #::Sequel::Dataset.class_eval do

        def paginate_with_safe_page(page_no, page_size, record_count=nil)
          page_no = page_no.to_i
          page_no = page_no == 0 ? 1 : page_no
          paginate_without_safe_page(page_no, page_size, record_count)
        end

        # alias_method_chain :paginate, :safe_page

      #end

    end

  end
end

Sequel.extension :pagination
module Kaminari
  module SequelPagination

    def self.included(base)
      base.class_eval do
        alias :num_pages :page_count
        alias :total_pages :page_count
        alias :limit_value :page_size
      end
    end
  end
end

Sequel::Dataset::Pagination.send(:include, Kaminari::SequelPagination)
# Sequel::DatasetPagination.send(:include, Kaminari::Sequel)
