require "lib/model_util"

namespace :parser do 
  desc "Convert xml model to json representation"
  task :convert_to_json, :in, :out do |t,args|
    json =  ModelUtil.convert_to_json(File.read(args.in))
    File.open(args.out,"w") do |f|
      f.puts json 
    end
  end
end