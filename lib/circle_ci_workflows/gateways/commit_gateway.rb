# frozen_string_literal: true

require 'json'
require 'http'

module CircleCiWorkflows
  module Gateways
    class CommitGateway
      def initialize(owner:, github_repo:, api_token:)
        @api_token = api_token
        @owner = owner
        @github_repo = github_repo
      end

      def find_latest_commit(branch)
        all_jobs = fetch_jobs(branch: branch)

        if all_jobs.empty?
          puts "No jobs found for github.com/#{@owner}/#{@github_repo} - #{branch}"
          exit(-1)
        end

        committer_date = all_jobs.first['committer_date']

        Core::Entities::Commit.new(
          date: Time.parse(committer_date).strftime("%h %d %H:%M"),
          author: all_jobs.first['user']['login'],
          revision: all_jobs.first['vcs_revision'],
          subject: all_jobs.first['subject'],
          jobs: extract_jobs_for_commit(
            all_jobs: all_jobs,
            commit_date: committer_date
          )
        )
      end

      private def extract_jobs_for_commit(all_jobs:, commit_date:)
        all_jobs
          .select { |job| job['committer_date'] == commit_date }
          .map { |job| extract_job(job) }
      end

      private def extract_job(circle_job)
        Core::Entities::Job.new(
          name: circle_job['job_name'] || circle_job['workflows']['job_name'],
          status: circle_job['status'],
          queued_at: circle_job['queued_at'],
          start_at: circle_job['start_at'],
          build_time: calculate_build_time_in_seconds(circle_job)
        )
      end

      private def calculate_build_time_in_seconds(circle_job)
        if circle_job['build_time_millis']
          circle_job['build_time_millis'].to_i / 1000
        elsif circle_job['queued_at']
          (Time.now - Time.parse(circle_job['queued_at'])).to_i
        elsif circle_job['start_at']
          (Time.now - Time.parse(circle_job['start_at'])).to_i
        else
          0
        end
      end

      private def fetch_jobs(branch:)
        api_url = "https://circleci.com/api/v1.1/project/github/#{@owner}/#{@github_repo}/tree/#{branch}"

        JSON.parse(
          HTTP
            .headers('Accept' => "application/json")
            .basic_auth(user: @api_token, pass: "")
            .get(api_url).to_s
        )
      end
    end
  end
end

