

module CircleCiWorkflows
  module UI
    class CLI
      def initialize
        @remote_url = `git remote get-url origin`
      end

      def get_user_input
        ARGV[0]
      end

      def get_github_repo
        @remote_url.split(/[\/:]/)[-1].split('.').first
      end

      def get_github_repo_owner
        @remote_url.split(/[\/:]/)[-2]
      end

      def get_current_branch
        `git rev-parse --abbrev-ref HEAD`
      end

      def render_workflow_for(commit:, clear: false)
        system "clear" if clear
        puts "#{decorate_status(commit.status)} #{commit.subject}"
        puts "   #{commit.date} - #{commit.author} - #{commit.revision[0..8]}"
        puts

        commit.jobs
          .sort_by(&:status)
          .map do |job|
          puts "  - #{decorate_status(job.status)} #{job.name.ljust(25)} #{human_time(job.build_time)}"
        end
      end

      def notify_successful_build(branch:)
        title = '✅ CircleCI Build Passed ✅'
        message = "Build passed for branch: #{branch}"

        system "osascript -e 'display notification \"#{message}\" with title \"#{title}\"'"
      end

      def notify_failed_build(branch:)
        title = '❌ CircleCI Build Failed ❌'
        message = "Build failed for branch: #{branch}"

        system "osascript -e 'display notification \"#{message}\" with title \"#{title}\"'"
      end

      def open_url(url)
        system "open #{url}"
      end

      private def human_time(duration_in_seconds)
        return if duration_in_seconds.nil?

        min = duration_in_seconds / 60
        sec = duration_in_seconds % 60

        s = ""
        s << "#{min}m " if min > 0
        s << "#{sec}s" if sec > 0

        s
      end

      private def get_origin
        @origin ||= `git remote get-url origin`
      end

      private def decorate_status(status)
        case status
        when "success"
          "✅ "
        when "failed", "failing"
          "❌ "
        when "queued", "not_running"
          "⏳ "
        when "running"
          "🚀 "
        else
          status
        end
      end

      module InputOptions
        STATUS = 'status'
        WATCH = 'watch'
        OPEN = 'open'
      end
    end
  end
end


