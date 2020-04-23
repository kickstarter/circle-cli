# frozen_string_literal: true

module CircleCiWorkflows
  module Core
    module Entities
      class Commit
        attr_reader :date, :author, :revision, :subject, :jobs

        def initialize(date:, author:, revision:, subject:, jobs:)
          @date = date
          @author = author
          @revision = revision
          @subject = subject
          @jobs = jobs
        end

        def status
          return 'success' if @jobs.all? { |j| j.status == 'success' }
          return 'failed' if @jobs.all? { |j| j.status == 'failed' }
          return 'failing' if @jobs.any? { |j| j.status == 'failed' }
          return 'running' if @jobs.any? { |j| j.status == 'running' }
          return 'not_running' if @jobs.any? { |j| j.status == 'not_running' }
          return 'queued' if @jobs.any? { |j| j.status == 'queued' }

          @jobs.map(&:status).uniq
        end
      end
    end
  end
end
