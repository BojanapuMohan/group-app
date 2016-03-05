module CallOut
  class Pipeline
    class SortFinder

      attr_accessor :filter

      def initialize(filter)
        @filter = filter
      end

      def sorter
        case
        when EmployeesRole.rn_or_lnp_roles.include?(filter.employee_role)
          RnLpnCasualSorter
        when shared_duty_shift?
          SharedDutyShiftSorter
        else
          Sorter
        end
      end

      def shared_duty_shift?
        filter.employee_role.housekeeper? && filter.facility.has_shared_duty_shifts?
      end

    end
  end
end

