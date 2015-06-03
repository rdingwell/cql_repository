
class Document
  include Mongoid::Document
  include Mongoid::Timestamps
 

  field :data, type: String
  field :library, type: String
  field :version, type: String
  field :dependencies, type: Hash, default: {}
  
  belongs_to :user

  validates_presence_of :data
  validates_presence_of :library
  # before create validate only lib/version combo
  validate({on: :create}) do |record|
    if Document.where(library: record.library, version: record.version).count > 0
      record.errors.add(:base, "Another library was found with the same identifier and version")
    end
  end

  # # before save validate dependencies exist
  validate do|record|
    record.dependencies.each_pair do |k,v|
      if Document.where(library: k, version: v).count == 0
        record.errors.add(:base, "Could not find dependency #{k}/#{v}")
      end
    end
  end

  before_destroy do |record|
    if Document.where(library: record.library, version: record.version).count > 0
      raise  "Document is used as a dependency for another document"
    end
  end
  

  def self.parse_dependencies(cql)
    deps = {}
    cql.lines.each do |l|
      line = l.strip
      if line.match /^include/
          parts = line.split
          if parts.length == 4
            # no version info
            deps[parts[1]] = nil
          elsif parts.length == 6
            # has version info
             deps[parts[1]] = parts[3].gsub("'", "")
          end
      end
    end
    deps
  end

  def self.parse_library_and_version(cql)
    library = nil
    version = nil

    cql.lines.each do |l|
      line = l.strip
      if line.match /^library/
          parts = line.split
          if parts.length == 2
            library = parts[1]
          elsif parts.length == 4
            library = parts[1]
            version = parts[3].gsub("'", "")
          end
      end
    end
    [library,version]
  end


  def self.find_or_create_by_cql(cql)
    library,version = parse_library_and_version(cql)
    document = Document.where(library: library, version: version).first
    unless document
      document = Document.new(library: library, 
                              version: version, data: cql, 
                              dependencies: parse_dependencies(cql))
      document.save
    end
    document
  end

  def find_dependencies
    crit = Document.all
    self.dependencies.each_pair do |k,v|
      crit = crit.or(library: k, version: v)
    end
    crit
  end

  def find_dependents
    Document.where("dependencies.#{library}" => version)
  end

end
