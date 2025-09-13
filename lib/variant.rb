require_relative './lemma'
require_relative './util'

class Variant
  attr_reader :entry, :lemma

  def initialize(entry, lemma, tags: [], forms: [])
    @entry = entry
    @lemma = Lemma.new(lemma, entry.part_of_speech, tags: tags, forms: forms)
  end

  def save!
    if lemma.valid?
      entry.variants << self
    else
      entry.failures << self
      return false
    end
  end

  def key
    Util.bare_form(lemma.lemma)
  end

  def key_exact
    lemma.lemma
  end

  def postag
    @lemma.postag
  end

  def to_s
    @lemma.to_s
  end

  def inspect
    to_s
  end
end
