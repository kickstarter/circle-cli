# frozen_string_literal: true

module CircleCiWorkflows
  module Core
    module UseCases
      class WatchLatestCommitWorkflow
        def initialize(cli:, commit_gateway:)
          @cli = cli
          @commit_gateway = commit_gateway
        end

        def execute(branch:)
          loop do
            commit = @commit_gateway.find_latest_commit(branch)

            @cli.render_workflow_for(commit: commit, clear: true)

            if commit.status == 'success'
              @cli.notify_successful_build(branch: branch)
              break
            elsif commit.status == 'failed'
              @cli.notify_failed_build(branch: branch)
              break
            end
          end
        end
      end
    end
  end
end

