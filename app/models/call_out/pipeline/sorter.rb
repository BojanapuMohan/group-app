module CallOut
  class Pipeline
    class Sorter

      attr_accessor :employee_call_outs

      def initialize(employee_call_outs)
        @employee_call_outs = employee_call_outs.select {|employee_call_out| employee_call_out.eligible?}
      end

      def sort!
        sorted.each_with_index {|employee_call_out, index| employee_call_out.update_attribute(:position, index)}
      end

      def sorted
        regular_time_call_outs(employee_call_outs) + overtime_call_outs(employee_call_outs)
      end

      def regular_time_call_outs(call_outs)
        call_outs.select {|employee_call_out| employee_call_out.regular_time? }.sort_by {|employee_call_out| employee_call_out.employee_seniority }.reverse
      end

      def overtime_call_outs(call_outs)
        call_outs.select {|employee_call_out| employee_call_out.overtime? }.shuffle
      end
    end
  end
end

