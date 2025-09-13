require_relative './util'
require_relative './variant'

class Entry
  PART_OF_SPEECH_MAP = {
    'noun' => :noun,
    'name' => :noun,
    'character' => :noun,

    'verb' => :verb,

    'adj' => :adjective,

    'adv' => :adverb,

    'article' => :article,

    'particle' => :particle,

    'conj' => :conjuncton,

    'prep' => :adposition,
    'postp' => :adposition,

    'pron' => :pronoun,

    'num' => :number,

    'intj' => :interjection,
  }

  attr_reader :dictionary, :headword, :part_of_speech, :failures, :variants

  def initialize(dictionary, headword, part_of_speech)
    @dictionary = dictionary
    @headword = headword
    @failures = []
    @part_of_speech = Entry::PART_OF_SPEECH_MAP[part_of_speech]
    @variants = []
  end

  def key
    Util.bare_form(headword)
  end

  def create_variant(lemma, tags: [], forms: [])
    Variant.new(self, lemma, tags: tags, forms: forms)
  end

  def compact_and_update_dictionary!
    variants.uniq!(&:to_s)

    variants.each { |v| dictionary.add_variant(v) }

    self
  end

  def to_s
    [
      headword
    ]
  end

  def inspect
    to_s
  end
end
