require "spec_helper"

describe ShiftOccurrencesController do
  describe :routing do
    it "should route to show" do
      get("facility/2/shift_occurrences/123/2014-01-01").should route_to("shift_occurrences#show", facility_id: "2", shift_id: "123", date: '2014-01-01')
    end
  end
end
