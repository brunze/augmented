require_relative 'chainable_procs'

module Refies
  module TransformableHashes
    refine Hash do

      def transform transforms
        raise ArgumentError, 'transformations must be specified as an Hash' unless transforms.kind_of? Hash

        transforms.each_with_object({}) do |(key, procable), new_hash|
          value = self[key]

          if procable.kind_of?(Hash) && value.kind_of?(Hash)
            new_hash[key] = value.transform procable
          elsif value.respond_to? :each
            new_hash[key] = value.map{ |thing| thing.transform procable }
          else
            new_hash[key] = Helpers.make_one_proc(procable).call value
          end
        end
      end

      def transform! transforms
        raise ArgumentError, 'transformations must be specified as an Hash' unless transforms.kind_of? Hash

        transforms.each do |key, procable|
          value = self[key]

          if procable.kind_of?(Hash) && value.kind_of?(Hash)
            self[key] = value.transform! procable
          elsif value.respond_to? :each
            self[key] = value.each{ |thing| thing.transform! procable }
          else
            self[key] = Helpers.make_one_proc(procable).call value
          end
        end

        self
      end

    end


    module Helpers
      using ChainableProcs

      def self.make_one_proc thing
        if thing.kind_of?(Array)
          thing.map(&:to_proc).reduce{ |chain, proc| chain | proc }
        else
          thing.to_proc
        end
      end

    end

    private_constant :Helpers
  end
end