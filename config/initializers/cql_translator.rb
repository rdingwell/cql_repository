require 'java'
require 'model_util'
ModelUtil.load_model_info
ModelUtil::JavaUtil::LibrarySourceLoader.registerProvider(ModelUtil::SourceLoader.new)