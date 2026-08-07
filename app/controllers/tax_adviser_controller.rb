class TaxAdviserController < ApplicationController
  before_action :load_conversations
  before_action :find_conversation, only: [:chat, :ask]

  def show
  end

  def create
    conversation = current_user.tax_adviser_conversations
                               .left_joins(:tax_adviser_messages)
                               .where(
                                 title: "New chat",
                                 tax_adviser_messages: { id: nil }
                               )
                               .first

    conversation ||= current_user.tax_adviser_conversations.create!(
      title: "New chat"
    )

    redirect_to tax_adviser_chat_path(conversation)
  end

  def chat
    @messages = @conversation.tax_adviser_messages.order(:created_at)
  end

  def widget
    @conversation = current_user.tax_adviser_conversations.order(updated_at: :desc).first
    @conversation ||= current_user.tax_adviser_conversations.create!(title: "New chat")
    @messages = @conversation.tax_adviser_messages.order(:created_at)

    render :chat
  end

  def ask
    question = params[:question].to_s.strip

    if question.blank?
      flash[:alert] = "Please enter a question."
      redirect_to tax_adviser_chat_path(@conversation)
      return
    end

    answer = TaxAdviser.new(current_user, question).call

    @conversation.tax_adviser_messages.create!(
      user: current_user,
      question: question,
      answer: answer
    )

    if @conversation.title == "New chat"
      @conversation.update!(title: question.truncate(38))
    else
      @conversation.touch
    end

    redirect_to tax_adviser_chat_path(@conversation)
  rescue TaxAdviser::AdviserFailed
    flash[:alert] = "The adviser could not answer right now."
    redirect_to tax_adviser_chat_path(@conversation)
  end

  private

  def load_conversations
    @conversations = current_user
                     .tax_adviser_conversations
                     .joins(:tax_adviser_messages)
                     .distinct
                     .order(updated_at: :desc)
  end

  def find_conversation
    @conversation = current_user
                    .tax_adviser_conversations
                    .find(params[:id])
  end
end
