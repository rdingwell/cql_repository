class Document
  include Mongoid::Document
  include Mongoid::Timestamps
  include DocumentValidators

  field :data, type: String
  field :library, type: String
  field :version, type: String
  field :dependencies, type: Hash, default: {}
  
  belongs_to :user

  validates_presence_of :data
  validates_presence_of :library
  # before create validate only lib/version combo
  validates_unique_library on: :create
  # before save validate dependencies exist
  validates_dependencies_exist
  # before delete check dependencies
  before_destroy :validates_not_a_dependency
  

  def self.parse_dependencies(cql)
    deps = {}
    cql.lines.each do |l|
      line = l.trim
      if line.match /^include/
          parts = line.split
          if parts.length == 4
            # no version info
            deps[parts[1]] = nil
          elsif parts.length == 6
            # has version info
             deps[parts[1]] = parts[3]
          end
      end
    end
    deps
  end

  def self.parse_library_and_version(cql)
    library = nil
    version = nil

    cql.lines.each do |l|
      line = l.trim
      if line.match /^library/
          parts = line.split
          if parts.length == 2
            library = parts[1]
          elsif parts.length == 4
            library = parts[1]
            version = parts[3]
          end
      end
    end
    library,version
  end

  def find_dependencies
    crit = self.where
    self.dependencies.each_pair do |k,v|
      crit = crit.or(library: k, version: v)
    end
    crit
  end

  def find_dependents
    self.where(library: self.library, version: self.version)
  end

end
