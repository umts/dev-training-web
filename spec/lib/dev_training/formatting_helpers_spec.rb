# frozen_string_literal: true

require 'dev_training/formatting_helpers'

RSpec.describe DevTraining::FormattingHelpers do
  let :formatter do
    Class.new { include DevTraining::FormattingHelpers }.new
  end

  describe '.format_body' do
    let(:body) { <<~BODY }
      This is an example issue body.

      It has two paragraphs.
    BODY

    it 'is a private method when included' do
      expect(formatter.private_methods).to include(:format_body)
    end

    context 'without subtasks' do
      subject(:call) { described_class.format_body(body) }

      it 'passes along the body' do
        expect(call).to eq body
      end

      it 'permits an empty description' do
        expect(described_class.format_body(nil)).to be_nil
      end
    end

    context 'with subtasks' do
      subject(:call) { described_class.format_body(body, [1, 2]) }

      it 'contains the body' do
        expect(call).to include(body)
      end

      it 'appends a tasklist' do
        expect(call.scan(/\* \[ \]/).count).to be 2
      end
    end
  end

  describe '.format_checklist' do
    subject(:call) { described_class.format_checklist([1, 2]) }

    it 'is a private method when included' do
      expect(formatter.private_methods).to include(:format_checklist)
    end

    it 'makes a tasklist item for each task' do
      expect(call.lines.count).to be 2
    end

    it 'makes each line a "tasklist" in GFM' do
      expect(call.lines).to all include('* [ ]')
    end
  end
end
