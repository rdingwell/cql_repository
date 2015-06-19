require 'test_helper'

  module Api
  class DocumentsControllerTest < ActionController::TestCase

    setup do
        dump_database
        load_fixtures
    end

    test "should be able to retreive a document as cql (default)" do
      get :show, library: "ChlamydiaScreening_CDS", version: "2", format: 'cql'
      assert_response :success
    end

    test "should be able to retrieve all documents" do
      get :index
      assert_response :success
    end

    test "should be able to retreive a document as elm xml" do
      get :show, library: "ChlamydiaScreening_CDS", version: "2", format: 'xml'
      assert_response :success
    end

    test "should be able to retreive a document as elm json" do
      get :show, library: "ChlamydiaScreening_CDS", version: "2", format: 'json'
      assert_response :success
    end

    test "should be able to create a document" do
      fixture_file = fixture_file_upload("test/fixtures/sample_cql.cql")
      post :create, file: fixture_file
      assert_response :success
    end

    test "should be able to update a document" do
      fixture_file = fixture_file_upload("test/fixtures/cql_documents/ChlamydiaScreening_CDS.cql")
      post :update, library: "ChlamydiaScreening_CDS", version: "2", file: fixture_file
      assert_response :success
    end

    test "should not create a document if on exists with same library / version" do
      fixture_file = fixture_file_upload("test/fixtures/cql_documents/ChlamydiaScreening_CDS.cql")
      post :create, file: fixture_file
      assert_response :bad_request
    end

    test "should not be able to save document that has unresolved dependencies" do
      assert false
    end

    test "should not be able to save document with circular dependencies" do
      assert false
    end

    test "should be able to retreive dependency graph for document" do
      assert false
    end

    test "should be able to retrieve full dependency graph" do
      assert false
    end

  end
end
