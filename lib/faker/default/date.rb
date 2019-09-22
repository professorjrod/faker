# frozen_string_literal: true

module Faker
  class Date < Base
    class << self
      ##
      # Produce a random date between two dates.
      #
      # @param from [Date] The start of the usable date range.
      # @param to [Date] The end of the usable date range.
      # @return [Date]
      #
      # @example
      #   Faker::Date.between(from: 2.days.ago, to: Date.today)
      #     #=> #<Date: 2014-09-24>
      #
      # @faker.version 1.0.0
      def between(legacy_from = NOT_GIVEN, legacy_to = NOT_GIVEN, from:, to:)
        warn_for_deprecated_arguments do |keywords|
          keywords << :from if legacy_from != NOT_GIVEN
          keywords << :to if legacy_to != NOT_GIVEN
        end

        from = get_date_object(from)
        to   = get_date_object(to)

        Faker::Base.rand_in_range(from, to)
      end

      # rubocop:disable Metrics/ParameterLists

      ##
      # Produce a random date between two dates.
      #
      # @param from [Date] The start of the usable date range.
      # @param to [Date] The end of the usable date range.
      # @param excepted [Date] A date to exclude.
      # @return [Date]
      #
      # @example
      #   Faker::Date.between_except(from: 1.year.ago, to: 1.year.from_now, excepted: Date.today)
      #     #=> #<Date: 2014-10-03>
      #
      # @faker.version 1.6.2
      def between_except(legacy_from = NOT_GIVEN, legacy_to = NOT_GIVEN, legacy_excepted = NOT_GIVEN, from:, to:, excepted:)
        warn_for_deprecated_arguments do |keywords|
          keywords << :from if legacy_from != NOT_GIVEN
        end
        warn_for_deprecated_arguments do |keywords|
          keywords << :to if legacy_to != NOT_GIVEN
        end
        warn_for_deprecated_arguments do |keywords|
          keywords << :excepted if legacy_excepted != NOT_GIVEN
        end

        raise ArgumentError, 'From date, to date and excepted date must not be the same' if from == to && to == excepted

        excepted = get_date_object(excepted)

        loop do
          date = between(from: from, to: to)
          break date.to_date if date != excepted
        end
      end
      # rubocop:enable Metrics/ParameterLists

      ##
      # Produce a random date in the future (up to N days).
      #
      # @param days [Integer] The maximum number of days to go into the future.
      # @return [Date]
      #
      # @example
      #   Faker::Date.forward(days: 23) #=> #<Date: 2014-10-03>
      #
      # @faker.version 1.0.0
      def forward(legacy_days = NOT_GIVEN, days: 365)
        warn_for_deprecated_arguments do |keywords|
          keywords << :days if legacy_days != NOT_GIVEN
        end

        from = ::Date.today + 1
        to   = ::Date.today + days

        between(from: from, to: to).to_date
      end

      ##
      # Produce a random date in the past (up to N days).
      #
      # @param days [Integer] The maximum number of days to go into the past.
      # @return [Date]
      #
      # @example
      #   Faker::Date.backward(days: 14) #=> #<Date: 2019-09-12>
      #
      # @faker.version 1.0.0
      def backward(legacy_days = NOT_GIVEN, days: 365)
        warn_for_deprecated_arguments do |keywords|
          keywords << :days if legacy_days != NOT_GIVEN
        end

        from = ::Date.today - days
        to   = ::Date.today - 1

        between(from: from, to: to).to_date
      end

      ##
      # Produce a random date in the past (up to N days).
      #
      # @param min_age [Integer] The minimum age that the birthday would imply.
      # @param max_age [Integer] The maximum age that the birthday would imply.
      # @return [Date]
      #
      # @example
      #   Faker::Date.birthday(min_age: 18, max_age: 65) #=> #<Date: 1986-03-28>
      #
      # @faker.version 1.4.3
      def birthday(legacy_min_age = NOT_GIVEN, legacy_max_age = NOT_GIVEN, min_age: 18, max_age: 65)
        warn_for_deprecated_arguments do |keywords|
          keywords << :min_age if legacy_min_age != NOT_GIVEN
        end
        warn_for_deprecated_arguments do |keywords|
          keywords << :max_age if legacy_max_age != NOT_GIVEN
        end

        t = ::Date.today

        from = birthday_date(t, max_age)
        to   = birthday_date(t, min_age)

        between(from: from, to: to).to_date
      end

      private

      def birthday_date(date, age)
        year = date.year - age

        day =
          if date.day == 29 && date.month == 2 && !::Date.leap?(year)
            28
          else
            date.day
          end

        ::Date.new(year, date.month, day)
      end

      def get_date_object(date)
        date = ::Date.parse(date) if date.is_a?(::String)
        date = date.to_date if date.respond_to?(:to_date)
        date
      end
    end
  end
end
