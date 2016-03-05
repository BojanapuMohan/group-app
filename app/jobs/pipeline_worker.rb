class PipelineWorker
  include SuckerPunch::Job

  def perform(employee_call_out_list_id, call_out_shift_id)
    call_out_list = EmployeeCallOutList.find(employee_call_out_list_id)
    call_out_shift = CallOutShift.find(call_out_shift_id)
    CallOut::Pipeline.new(call_out_list.employee_call_outs, call_out_shift).call
    call_out_list.update_attribute(:filtered_at, Time.now)
  end

  def self.run_pipeline(employee_call_out_list, call_out_shift)
    new.async.perform(employee_call_out_list.id, call_out_shift.id)
  end
end
