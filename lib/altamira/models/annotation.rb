# frozen_string_literal: true

require 'altamira/models/scored_event'
require 'xmlsimple'

module Altamira
  # Represents a set of Annotation of an EDF, including sleep stages, epoch
  # length, and scored events.
  class Annotation
    attr_accessor :filename, :xml, :epoch_length, :sleep_stages, :scored_events

    def initialize(filename)
      @filename = filename
      @xml = XmlSimple.xml_in(filename)
      @epoch_length = parse_epoch_length
      @sleep_stages = parse_sleep_stages
      @scored_events = parse_scored_events
    end

    private

    def parse_epoch_length
      @xml['EpochLength'][0].to_i
    end

    def parse_sleep_stages
      (@xml['SleepStages'][0]['SleepStage'] || []).collect(&:to_i)
    end

    def parse_scored_events
      (@xml['ScoredEvents'][0]['ScoredEvent'] || []).collect do |hash|
        hash = {
          name: extract(hash, 'Name'),
          lowest_spo2: extract(hash, 'LowestSpO2', convert: :to_f),
          desaturation: extract(hash, 'Desaturation', convert: :to_f),
          start: extract(hash, 'Start', convert: :to_f),
          duration: extract(hash, 'Duration', convert: :to_f),
          input: extract(hash, 'Input')
        }
        scored_event = Altamira::ScoredEvent.new(hash)
        scored_event.set_stage(@sleep_stages, @epoch_length)
        scored_event
      end
    end

    def extract(hash, key, convert: nil)
      value = hash[key] ? hash[key][0] : nil
      convert && value ? value.send(convert) : value
    end
  end
end
