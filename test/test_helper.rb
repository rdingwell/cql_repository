ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase

  def dump_database
    Document.delete_all
    db = Mongoid.default_session
    db['documents'].drop
  end

  def load_fixtures
    Dir.glob(File.join(Rails.root, 'test', 'fixtures', 'cql_documents', '*.cql')).each do |cql_document|
      cql = File.read(cql_document)
      doc = Document.find_or_create_by_cql(cql)
      library,version = Document.parse_library_and_version(cql)

      doc.save
    end
  end

end
