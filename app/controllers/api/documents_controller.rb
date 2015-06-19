require 'java'

module Api
class DocumentsController < ApplicationController

  api :GET, "/documents", "Get a list of documents"
  formats ['json']
  def index
    @documents = Document.all().as_json
    render json: @documents
  end

  api :GET, "/documents/:library/:version", "Retrieve an individual document"
  formats ['json']
  param :library, String, :desc => "Document Library", :required => true
  param :version, String, :desc => "Document Version", :required => true
  def show
    @document = Document.where(library: params[:library], version: params[:version]).first

    if @document
      respond_to do |format|
        format.cql {render text: @document.data}
        format.xml {render xml: org.cqframework.cql.cql2elm.CqlTranslator.fromText(@document.data).toXml()}
        format.json {render json: org.cqframework.cql.cql2elm.CqlTranslator.fromText(@document.data).toJson()}
      end
    else
      render :status => :not_found, :text => "Document not found."
    end
  end

  api :POST, "/documents", "Load a document into the respository"
  formats ['cql']
  param :file, nil, :desc => "The CQL file", :required => true
  def create
    cql = File.read(params[:file])
    library, version = Document.parse_library_and_version(cql)
    @document = Document.new(library: library, version: version, data: cql, dependencies: Document.parse_dependencies(cql))
    if @document.save
      render status: 201, text: 'Document Imported'
    else
      render :status => :bad_request, :text => @document.errors.messages[:base]
    end
  end

  api :POST, "/documents/:library/:version", "Update a document"
  formats ['json']
  param :library, String, :desc => "Document Library", :required => true
  param :version, String, :desc => "Document Version", :required => true
  param :file, nil, :desc => "The updated CQL file", :required => true
  def update
    cql = File.read(params[:file])
    @document = Document.where(library: params[:library], version: params[:version]).first
    @document.data = cql
    @document.dependencies = Document.parse_dependencies(cql)
    if @document.save
      render status: 201, text: 'Document Updated'
    else
      render :status => :internal_server_error, :text => @document.errors.messages[:base]
    end
  end
end
end
