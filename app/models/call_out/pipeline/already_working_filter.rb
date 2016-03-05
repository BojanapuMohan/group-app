module CallOut
  class Pipeline
    class AlreadyWorkingFilter < Filter

      def call
        reject! if overlap_on_any_call_out_dates?
      end

      def overlap_on_any_call_out_dates?
        overlapping_occurences.present?
      end

    end
  end
end
