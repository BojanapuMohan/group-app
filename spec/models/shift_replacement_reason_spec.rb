require 'spec_helper'

describe ShiftReplacementReason do
  it {should have_many(:employee_shifts)}
end
