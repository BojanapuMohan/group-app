require 'spec_helper'

describe Facility do
  it{should have_many(:shifts)}

  let(:facility) {build_stubbed(:facility)}

end
