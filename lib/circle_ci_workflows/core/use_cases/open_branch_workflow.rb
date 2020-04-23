# frozen_string_literal: true

module CircleCiWorkflows
  module Core
    module UseCases
      class OpenBranchWorkflow
        def initialize(cli:)
          @cli = cli
        end

        def execute(branch:)
          workflow_url = "https://circleci.com/gh/#{@cli.get_github_repo_owner}/workflows/#{@cli.get_github_repo}/tree/#{escape_slashes(branch)}"

          @cli.open_url(workflow_url)
        end

        private def escape_slashes(text)
          text.gsub('/', '%2F')
        end
      end
    end
  end
end


