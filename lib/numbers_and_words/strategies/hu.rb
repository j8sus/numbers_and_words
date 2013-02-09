module NumbersAndWords
  module Strategies
    class Hu < Base
      include Families::Latin
      include Extensions::FractionSignificance
      include NumbersAndWords::TranslationsHelpers::Hu

      def with_fraction
        [integer_part, fraction_separator, fractional_part].join(' ')
      end

      def integer_part
        words.empty? && zero || inner_reverse_words(words).reverse.join(greater_than_2000? && '-' || '')
      end

      def fractional_part
        significance, *words = fraction_words
        fraction = inner_reverse_words(words).reverse.join(greater_than_2000?(fraction_figures) && '-' || '')
        [fraction, significance].join ' '
      end

      private

      def inner_reverse_words words = words
        words.collect { |iteration| iteration.reverse.join }
      end

      def greater_than_2000? figures = figures
        figures.length > 4 || (figures.length == 4 && figures.last >= 2)
      end

      def strings
        if figures.capacity_count
          number_without_capacity_to_words + complex_number_to_words
        elsif figures.hundreds
          [hundreds_number_to_words]
        elsif figures.tens or figures.ones
          [simple_number_to_words]
        else
          []
        end
      end

      def complex_number_to_words
        count = figures.capacity_count
        (1..count).map { |capacity| capacity_iteration(capacity).flatten }.reject(&:empty?)
      end

      def simple_number_to_words
        if figures.teens || figures.tens
          [complex_tens]
        elsif figures.ones
          [translation_ones(figures.ones)]
        else
          []
        end
      end
    end
  end
end
