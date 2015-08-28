require 'test_helper'
require "lib/model_parser"
class ModelParserTest < ActiveSupport::TestCase

  test "should be able to translate an xml model into json" do
    mod = File.read("test/fixtures/models/model.xml")
    converted = ModelParser.convert_to_json(mod)
    puts converted
    json = JSON.parse(converted)
    assert_equal  "QDM", json["name"]
    assert_equal 6, json["types"].length 
    assert_equal ["QDM.Patient", "QDM.DiagnosisActive", "QDM.LaboratoryTestPerformed", "QDM.EncounterPerformed", "QDM.QDMBaseType", "QDM.MedicationOrder"], json["types"].keys
    
    assert json
  end
end
