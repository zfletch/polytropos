require_relative './entry'
require_relative './util'

class Dictionary
  def initialize
    @headword_to_entries = {}
    @lemma_to_variants = {}
    @lemma_to_variants_exact = {}
  end

  def look_up(lemma)
    (@lemma_to_variants[Util.bare_form(lemma)] || []).flatten
  end

  def look_up_exact(lemma)
    (@lemma_to_variants_exact[lemma] || []).flatten
  end

  def forms_of(headword)
    (@headword_to_entries[Util.bare_form(headword)] || [])
      .map(&:variants).flatten
  end

  def add_entry(headword, part_of_speech)
    entry = Entry.new(self, headword, part_of_speech)

    @headword_to_entries[entry.key] ||= []
    @headword_to_entries[entry.key] << entry

    entry
  end

  def add_variant(variant)
    @lemma_to_variants[variant.key] ||= []
    @lemma_to_variants[variant.key] << variant

    @lemma_to_variants_exact[variant.key_exact] ||= []
    @lemma_to_variants_exact[variant.key_exact] << variant

    variant
  end

  def entries
    @headword_to_entries.values.flatten
  end

  def variants
    @lemma_to_variants.values.flatten
  end
end
