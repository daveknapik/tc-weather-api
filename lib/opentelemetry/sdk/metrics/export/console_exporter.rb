module OpenTelemetry
  module SDK
    module Metrics
      module Export
        class ConsoleExporter
          def initialize
            @stopped = false
          end

          def export(spans, timeout: nil)
            return FAILURE if @stopped

            Array(spans).each { |s| pp s }

            SUCCESS
          end

          def force_flush(timeout: nil)
            SUCCESS
          end

          def shutdown(timeout: nil)
            @stopped = true
            SUCCESS
          end
        end
      end
    end
  end
end