require 'java'
require 'model_parser'
ModelParser.load_model_info
ModelParser::JavaUtil::LibrarySourceLoader.registerProvider(ModelParser::SourceLoader.new)