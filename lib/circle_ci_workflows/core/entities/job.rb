# frozen_string_literal: true

module CircleCiWorkflows
  module Core
    module Entities
      class Job
        attr_reader :name, :status, :queued_at, :start_at, :build_time

        def initialize(name:, status:, queued_at:, start_at:, build_time:)
          @name = name
          @status = status
          @queued_at = queued_at
          @start_at = start_at
          @build_time = build_time
        end
      end
    end
  end
end
