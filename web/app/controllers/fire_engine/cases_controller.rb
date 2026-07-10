module FireEngine
  class CasesController < BaseController
    MOCK_THREAD_MESSAGES = [
      { user_id: "U0A5PLKMB25", text: "yeah i don't think that was okay to post in #general", posted_at: 2.days.ago - 4.minutes, reactions: [] },
      { user_id: "U01MOCKFD1", text: "on it, opening a case", posted_at: 2.days.ago - 3.minutes, reactions: [{ name: "hourglass", count: 1, reacted_by_current_case: true }] },
      { user_id: "U0B4RANDOM1", text: "same person did this last week too", posted_at: 2.days.ago - 1.minute, reactions: [{ name: "eyes", count: 2 }] },
      { user_id: "U01MOCKFD1", text: "confirmed, second occurrence — escalating to a warning", posted_at: 2.days.ago, reactions: [{ name: "hourglass", count: 1 }] }
    ].freeze

    ACTION_TYPE_OPTIONS = %w[warning temp_ban indef_ban perma_ban dm shush channel_ban locked_thread].freeze
    MOCK_CATEGORY_OPTIONS = ["NSFW content", "Harassment", "Spam", "Impersonation", "Other"].freeze

    def index
      @status_filter = params[:status].presence
      @cases = lyla.cases(status: @status_filter).map { |c| case_summary(c) }
      @open_count = @cases.count { |c| c[:status] == "open" }
      @unassigned_count = @cases.count { |c| c[:status] == "open" && c[:assignees].empty? }
      @aging_count = @cases.count { |c| c[:status] == "open" && c[:age_days] >= 5 }
    end

    def show
      raw_case = lyla.find_case(params[:id])
      return redirect_to(fire_engine_cases_path, alert: "no case found for that number") unless raw_case

      @case = case_summary(raw_case)
      @case_actions = (raw_case["actions"] || []).map { |a| case_action_summary(a) }
      @all_cases = lyla.cases.map { |c| case_summary(c) }
      @thread_messages = MOCK_THREAD_MESSAGES
      @action_type_options = ACTION_TYPE_OPTIONS
      @category_options = MOCK_CATEGORY_OPTIONS
    end

    private

    def lyla
      @lyla ||= LylaClient.new
    end

    def case_summary(c)
      threads = c["threads"] || []
      primary_thread = threads.find { |t| t["isPrimary"] } || threads.first
      opened_at = Time.at(c["createdAt"] / 1000.0)

      {
        case_number: c["caseNumber"],
        status: c["status"],
        opened_at: opened_at,
        age_days: ((Time.current - opened_at) / 1.day).to_i,
        channel: primary_thread&.dig("channel"),
        thread_ts: primary_thread&.dig("threadTs"),
        snippet: primary_thread&.dig("snippet"),
        assignees: (c["assignees"] || []).map { |a| a["userId"] }
      }
    end

    def case_action_summary(a)
      data = a["data"] || {}

      {
        case_number: a["caseNumber"],
        action_type: a["actionType"],
        target_user_id: a["targetUserId"],
        performed_by: (a["performedBy"] || []).join(", "),
        what_they_did: data["whatTheyDid"],
        ban_until: data["banUntil"].presence && Date.parse(data["banUntil"]),
        performed_at: Time.at(a["performedAt"] / 1000.0),
        thread_url: data["permalink"]
      }
    end
  end
end
