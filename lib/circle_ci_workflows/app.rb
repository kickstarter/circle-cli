require 'thor'

require 'circle_ci_workflows/version'
require 'circle_ci_workflows/ui/cli'
require 'circle_ci_workflows/gateways/commit_gateway'
require 'circle_ci_workflows/core/entities/commit'
require 'circle_ci_workflows/core/entities/job'
require 'circle_ci_workflows/core/use_cases/fetch_latest_commit_workflow'
require 'circle_ci_workflows/core/use_cases/watch_latest_commit_workflow'
require 'circle_ci_workflows/core/use_cases/open_branch_workflow'

module CircleCiWorkflows
  class App < Thor

    option :token
    desc 'watch', 'Watch the CircleCI workflow for your current branch'
    def watch
      initialize_dependencies(circle_ci_token: options[:token])

      @watch_latest_commit_workflow.execute(branch: @cli.get_current_branch)
    end

    option :token
    desc 'status', 'Print a snapshot of the current branches workflow'
    def status
      initialize_dependencies(circle_ci_token: options[:token])

      @fetch_latest_commit_workflow.execute(branch: @cli.get_current_branch)
    end

    option :token
    desc 'open', 'Open the CircleCI workflow for your current branch'
    def open
      initialize_dependencies(circle_ci_token: options[:token])

      @open_branch_workflow.execute(branch: @cli.get_current_branch)
    end


    no_commands {
      private def initialize_dependencies(circle_ci_token:)
        token = circle_ci_token || ENV['CIRCLE_CI_TOKEN']

        if token.nil?
          puts 'CIRCLE_CI_TOKEN is not defined. Please define it in your environment as CIRCLE_CI_TOKEN or pass it in with the --token flag'
          exit(-1)
        end

        @cli = UI::CLI.new
        @commit_gateway = Gateways::CommitGateway.new(
          owner: @cli.get_github_repo_owner,
          github_repo: @cli.get_github_repo,
          api_token: token
        )
        @fetch_latest_commit_workflow = Core::UseCases::FetchLatestCommitWorkflow.new(cli: @cli, commit_gateway: @commit_gateway)
        @watch_latest_commit_workflow = Core::UseCases::WatchLatestCommitWorkflow.new(cli: @cli, commit_gateway: @commit_gateway)
        @open_branch_workflow = Core::UseCases::OpenBranchWorkflow.new(cli: @cli)
      end
    }
  end
end
