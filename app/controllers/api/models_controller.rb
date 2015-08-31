module Api
  class ModelsController < ApplicationController

    def index
      render json: ModelUtil::MODELS.keys
    end

    def show
      model = ModelUtil::MODELS[params[:id]]
      if model
        render json: ModelUtil.convert_to_json(model)
      else
        render status: 404
      end
    end

  end
end