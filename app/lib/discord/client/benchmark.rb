# frozen_string_literal: true

module Discord
  class Client
    module Benchmark
      PREFIX = '[Discord API]'.bold.light_magenta.freeze

      # @param method_name [Symbol, String]
      # @return [void]
      def benchmark(method_name)
        old_method = instance_method(method_name)

        define_method(method_name) do |*args, **options, &block|
          label = "#{self.class.name}##{method_name}".yellow

          Rails.benchmark([' ', PREFIX, label].join(' ')) do
            old_method.bind_call(self, *args, **options, &block)
          end
        end
      end
    end
  end
end
