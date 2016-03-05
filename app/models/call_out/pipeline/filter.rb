module CallOut
  class Pipeline
    class Filter

      attr_accessor :pipeline, :employee_call_out, :call_out_shift, :context

      def initialize(pipeline, employee_call_out, call_out_shift, context = {})
        @pipeline = pipeline
        @employee_call_out = employee_call_out
        @call_out_shift = call_out_shift
        @context = context
      end

      def self.call(pipeline, employee_call_outs, call_out_shift, context = {})
        employee_call_outs.each do |employee_call_out|
          filter = new(pipeline, employee_call_out, call_out_shift, context)
          filter.call if filter.has_pre_conditions_met?
        end
        CallOut::Pipeline::Sorter.new(employee_call_outs).sort!
      end

      def call
        raise NotImplementedError
      end

      def has_pre_conditions_met?
        pre_conditions.detect {|pre_condition| pre_condition.call(self) == false}.nil?
      end

      def pre_conditions
        [->(filter) {true}]
      end

      def start_date
        pipeline.start_date
      end

      def starts_at
        shift_occurrences.first.date_time
      end

      def end_date
        pipeline.end_date
      end

      def shift_occurrences
        @shift_occurrences ||= pipeline.shift_occurrences
      end

      def shift_dates
        @shift_dates ||= shift_occurrences.map(&:date)
      end

      def shift_time_ranges
        @shift_time_ranges ||= shift_occurrences.map(&:time_range)
      end

      def overlapping_occurences(these_shifts = employee.shifts_worked_between(start_date, end_date))
        these_shifts.select {|working_shift| shift_time_ranges.map {|shift_time_range| shift_time_range.overlaps?(working_shift.time_range)}.any? }.flatten
      end

      def employee
        employee_call_out.employee
      end

      def employee_role
        pipeline.employees_role
      end

      def employee_class
        employee.employee_class
      end

      def rejected?
        employee_call_out.rejected?
      end

      def overtime?
        employee_call_out.overtime?
      end

      def call_out_shift
        pipeline.call_out_shift
      end

      def employees_role
        pipeline.employees_role
      end

      def facility
        pipeline.facility
      end

      def sorter
        CallOut::Pipeline::SortFinder.new(self).sorter
      end

      private

      def occurence_calculator
        @occurence_calculator ||= ShiftOccurrenceCalculator.new(employee.shifts_worked_between(start_date, end_date) + shift_occurrences - overlapping_occurences)
      end

      def incurs_overtime!
        employee_call_out.incurs_overtime!(self.class.to_s)
      end

      def reject!
        employee_call_out.reject!(self.class.to_s)
      end

      def accept!
        employee_call_out.accept!(self.class.to_s)
      end
    end
  end
end
