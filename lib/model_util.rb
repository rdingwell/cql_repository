require 'rexml/document'
require 'rexml/xpath'
module ModelUtil
  MODELS = {}
  module JavaUtil 
    include_package "javax.xml.bind"
    include_package "org.cqframework.cql.cql2elm"
    include_package "org.hl7.elm.r1"
    include_package "org.hl7.elm_modelinfo.r1"
    include_class "java.io.File"
  end



   T = JavaUtil::ModelInfoLoader
   def T.getModelInfoProvider(v)
    puts v
    puts "nope"
  end
  class SourceLoader
      # this needs to return a Java.io.InputStream so 
      def getLibrarySource(vi)
        id = vi.id
        version = vi.version
        cql = Document.where(library: id, version: version).first
        if cql 
          StringIO.new(cql.data).to_inputstream
        end
      end
  end
  


  def self.load_model_info()
    
    Dir.glob("./model_info/**/*.xml") do |file|
      xml = REXML::Document.new( File.read(file))
      MODELS[xml.root.attributes["name"]] = xml 
      modelInfoXML = JavaUtil::File.new(File.absolute_path(file))
      JavaUtil::CqlTranslator.loadModelInfo(modelInfoXML);
      # modelInfo = JavaUtil::JAXB.unmarshal(modelInfoXML, JavaUtil::ModelInfo.java_class);
      # puts "loading #{modelInfo.getName()} #{modelInfo.getVersion()}"
      # modelId = JavaUtil::VersionedIdentifier.new().withId(modelInfo.getName()).withVersion(modelInfo.getVersion());
      # modelProvider = lambda {return modelInfo}
      # JavaUtil::ModelInfoLoader.registerModelInfoProvider(modelId, modelProvider);
    end
   
   end

  def self.convert_to_json(model)
    return if !model
    if(model.kind_of? String )
       model = REXML::Document.new(model)
    end
    types = {}
    model_hash = {types: types, name: model.root.attributes["name"],patientClassName: model.root.attributes["patientClassName"]}
    REXML::XPath.each(model,"/ns:modelInfo/ns:typeInfo",{"ns" =>"urn:hl7-org:elm-modelinfo:r1"}) do  |typeInfo| 
      type = {} 
      type[:type] = typeInfo.attributes["name"]
      type[:baseType] = typeInfo.attributes["baseType"] if typeInfo.attributes["baseType"]
      type[:identifier] = typeInfo.attributes["identifier"] 
      type[:retrievable] = typeInfo.attributes["retrievable"] if typeInfo.attributes["baseType"]
      type[:label] = typeInfo.attributes["label"]
      type[:properties] = {}
      REXML::XPath.each(typeInfo,"ns:element",{"ns" =>"urn:hl7-org:elm-modelinfo:r1"}) do |element|
        type[:properties][element.attributes["name"]] = {name: element.attributes["name"], type: element.attributes["type"]}
      end
      types[type[:type]] = type
    end
    model_hash.to_json
  end

end