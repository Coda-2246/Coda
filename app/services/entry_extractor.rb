class EntryExtractor
  class ExtractionFailed < StandardError; end

  PROMPT = <<~PROMPT.squish
    Extract the transaction details from this receipt, invoice, or expense/income
    document and categorize it using the provided schema. If a field can't be
    determined from the document, make your best reasonable guess based on context.
  PROMPT

  Result = Struct.new(:attributes, :blob, keyword_init: true)

  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  def call
    blob = upload_blob
    data = extract(blob)

    raise ExtractionFailed, "couldn't understand the document's contents" unless data.is_a?(Hash)

    Result.new(attributes: build_attributes(data), blob: blob)
  rescue RubyLLM::Error,
         RubyLLM::ConfigurationError,
         RubyLLM::ModelNotFoundError,
         RubyLLM::UnsupportedAttachmentError => e
    Rails.logger.error("EntryExtractor failed: #{e.class}: #{e.message}")
    raise ExtractionFailed, "We couldn't process that document."
  end

  private

  attr_reader :uploaded_file

  def upload_blob
    ActiveStorage::Blob.create_and_upload!(
      io: uploaded_file,
      filename: uploaded_file.original_filename,
      content_type: uploaded_file.content_type
    )
  end

  def extract(blob)
    RubyLLM.chat
           .with_schema(EntryExtractionSchema)
           .ask(PROMPT, with: blob)
           .content
  end

  def build_attributes(data)
    {
      kind: data["kind"],
      category: data["category"],
      description: data["description"],
      amount: data["amount"],
      currency: data["currency"],
      entry_date: parse_date(data["entry_date"]),
      country_code: data["country_code"]
    }.compact
  end

  def parse_date(value)
    Date.parse(value.to_s)
  rescue ArgumentError, TypeError
    nil
  end
end
