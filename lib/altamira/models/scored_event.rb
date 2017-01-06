# frozen_string_literal: true

module Altamira
  # Represents a single scored event in an EDF, along with information present in
  # the signal at the location of the event.
  class ScoredEvent
    attr_accessor :name, :lowest_spo2, :desaturation, :start, :duration, :input,
                  :stage

    def initialize(hash = {})
      @name = hash[:name]
      @lowest_spo2 = hash[:lowest_spo2]
      @desaturation = hash[:desaturation]
      @start = hash[:start]
      @duration = hash[:duration]
      @input = hash[:input]
      @stage = nil
    end

    def set_stage(sleep_stages, epoch_length)
      return if @start.nil?
      index = (@start / epoch_length).floor
      @stage = sleep_stages[index]
    end
  end
end
