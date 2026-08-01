module TaxAdviserHelper
  def render_adviser_answer(answer)
    text = ERB::Util.html_escape(answer.to_s)

    text = text.gsub(/^### (.+)$/, '<h4 class="mt-3 mb-2">\1</h4>')
    text = text.gsub(/^## (.+)$/, '<h3 class="h5 mt-4 mb-2">\1</h3>')
    text = text.gsub(/^# (.+)$/, '<h3 class="h4 mt-4 mb-2">\1</h3>')
    text = text.gsub(/\*\*(.+?)\*\*/, '<strong>\1</strong>')
    text = text.gsub(/^- (.+)$/, '• \1')
    text = text.gsub("\n", "<br>")

    sanitize(
      text,
      tags: %w[h3 h4 strong br],
      attributes: %w[class]
    )
  end
end
