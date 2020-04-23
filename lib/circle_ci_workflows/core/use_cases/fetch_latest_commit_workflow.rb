module CircleCiWorkflows
  module Core
    module UseCases
      class FetchLatestCommitWorkflow
        def initialize(cli:, commit_gateway:)
          @cli = cli
          @commit_gateway = commit_gateway
        end

        def execute(branch:, rerender: false)
          commit = @commit_gateway.find_latest_commit(branch)

          @cli.render_workflow_for(commit: commit, clear: rerender)
        end
      end
    end
  end
end
