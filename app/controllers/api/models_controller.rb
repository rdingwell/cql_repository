module Api
  class ModelsController < ApplicationController

    def index
      render json: ModelUtil::MODELS.keys
    end

    def show
      mid = params[:id]
      mid.gsub!(".json","")
      model = ModelUtil::MODELS[mid]
      if model
        render json: ModelUtil.convert_to_json(model)
      else
        render status: 404, text: "Could not find model #{mid}"
      end
    end

  end
end