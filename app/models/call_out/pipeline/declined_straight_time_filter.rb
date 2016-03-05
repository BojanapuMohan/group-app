module CallOut
  class Pipeline
    class DeclinedStraightTimeFilter < Filter

      def pre_conditions
        [
          ->(filter) {filter.overtime?},
          ->(filter) {filter.call_out_shift.employee_call_out_lists.size > 1}
        ]
      end

      def call
        reject! if already_rejected_this_shift?
      end

      def already_rejected_this_shift?
        call_out_shift.employee_call_out_lists
          .map {|list| list.employee_call_outs}.flatten
          .select {|call_out| call_out.employee_id == employee.id}
          .select {|call_out| EmployeeCallOutResult.declined_results.include?(call_out.employee_call_out_result)}.present?
      end
    end
  end
end
