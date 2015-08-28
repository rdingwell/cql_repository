require "lib/model_parser"

namespace :parser do 
  desc "Convert xml model to json representation"
  task :convert_to_json, :in, :out do |t,args|
    json =  ModelParser.convert_to_json(File.read(args.in))
    File.open(args.out,"w") do |f|
      f.puts json 
    end
  end
end