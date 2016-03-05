module CallOut
  class Pipeline
    class  AlreadyWorkingRegularPtOverTimeFilter < Filter

      def pre_conditions
        [
          ->(filter) { filter.employee_class == Employee.part_time },
          ->(filter) { filter.starts_at > Time.now + 2.weeks },
          ->(filter) { filter.shift_occurrences.length >= 5  },
          ->(filter) { filter.overlaps_with_regularly_scheduled_shift? }
        ]
      end

      def call
        reject! if overtime?
      end

      def overlaps_with_regularly_scheduled_shift?
        overlapping_occurences(employee.regular_shifts_worked_between(start_date, end_date)).present?
      end

    end
  end
end
