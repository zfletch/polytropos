require_relative './lemma'
require_relative './util'

class Variant
  attr_reader :entry

  def initialize(entry, lemma, tags: [], forms: [])
    @entry = entry
    @lemma = Lemma.new(lemma, entry.part_of_speech, tags: tags, forms: forms)
  end

  def key
    Util.bare_form(lemma)
  end

  def lemma
    @lemma.lemma
  end

  def postag
    @lemma.postag
  end

  def to_s
    @lemma.to_s
  end
end
