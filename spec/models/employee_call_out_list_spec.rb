require 'spec_helper'

describe EmployeeCallOutList do
  it {should belong_to(:user)}
  it {should belong_to(:call_out_shift)}
  it {should have_many(:employee_call_outs)}
end
