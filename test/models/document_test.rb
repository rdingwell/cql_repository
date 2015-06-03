require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  def setup
    Document.collection.drop
  end


  test "should validate unique library/version" do
    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_CDS.cql")
    doc = Document.find_or_create_by_cql(cql)
    assert doc.errors.empty?

    library,version = Document.parse_library_and_version(cql)
    doc = Document.new(library: library, 
                            version: version, data: cql, 
                             dependencies: Document.parse_dependencies(cql))
    doc.save

    assert !doc.errors.empty?
  end

  test "should validate precense of library identifier" do
    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_CDS.cql")
    library,version = Document.parse_library_and_version(cql)
    doc = Document.new(library: library, 
                            version: version, data: cql, 
                             dependencies: Document.parse_dependencies(cql))
    doc.library = nil
    doc.save

    assert !doc.errors.empty?
  end


  test "should validate dependencies" do
    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_CDS_UsingCommon.cql")
    doc = Document.find_or_create_by_cql(cql)
    assert !doc.errors.empty?

    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_Common.cql")
    doc = Document.find_or_create_by_cql(cql)
    doc.save
    assert doc.errors.empty?

    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_CDS_UsingCommon.cql")
    doc = Document.find_or_create_by_cql(cql)
    assert doc.errors.empty? , "There should be no errors dependencies should have validated"
  end

  test "should parse dependencies" do
    cql = File.read("test/fixtures/cql_documents/include.cql")
    deps = Document.parse_dependencies(cql)
    assert_equal deps, {"withVersion" => "2","withoutVersion"=>nil}

  end

  test "should parse library and version" do
    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_CDS.cql")
    identifier,version = Document.parse_library_and_version(cql)
    assert_equal identifier, "ChlamydiaScreening_CDS"
    assert_equal version, "2"
  end

  test "should check for dependent documents on delete" do
    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_Common.cql")
    doc1 = Document.find_or_create_by_cql(cql)
    doc1.save
    assert doc1.errors.empty?

    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_CDS_UsingCommon.cql")
    doc = Document.find_or_create_by_cql(cql)
    assert doc.errors.empty?

   
  end

  test "should be able to retrieved dependencies" do
    
    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_Common.cql")
    doc1 = Document.find_or_create_by_cql(cql)
    doc1.save
    assert doc1.errors.empty?

    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_CDS_UsingCommon.cql")
    doc = Document.find_or_create_by_cql(cql)
    assert doc.errors.empty?

    assert_equal doc.find_dependencies.count() , 1, "should have one dependency"
    assert_equal doc1.id , doc.find_dependencies.first.id, "Dep id should match"
  end

  test "should be able to find dependent documents" do 
    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_Common.cql")
    doc1 = Document.find_or_create_by_cql(cql)
    doc1.save
    assert doc1.errors.empty?

    cql = File.read("test/fixtures/cql_documents/ChlamydiaScreening_CDS_UsingCommon.cql")
    doc = Document.find_or_create_by_cql(cql)
    assert doc.errors.empty?

    assert_equal doc1.find_dependents.count() , 1, "Should have 1 dependent"
    assert_equal doc.id , doc1.find_dependents.first.id, "Dependent id whould match"
  end


end
