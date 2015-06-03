class DocumentValidator < ActiveModel:Validator

  def validates_dependencies_exist(record)
    record.dependencies.each_pair do |k,v|
      if Document.where(library: k, version: v).count > 0
        record.errors.add "Could not find dependency #{k}/#{v}"
      end
    end
  end

  def validates_not_a_dependency(record)
    if Document.where(library: record.library, version: record.version).count > 0
      record.errors.add "Another library was found with the same identifier and version"
    end
  end

  def validates_unique_library(record)
    if Document.where(library: record.library, version: record.version).count > 0
      record.errors.add "Another library was found with the same identifier and version"
    end
  end
end