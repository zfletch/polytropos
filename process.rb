#!/usr/bin/env ruby

require 'json'
require 'optparse'

require_relative './lib/dictionary'
require_relative './lib/util'

# TODO Hack to get around issue in source data
def clean_up_definite_article(entry, lemma)
  regex = /\A(?:ὁ|ἡ|τό|τὸ|τοῦ|τῆς|τῷ|τῇ|τόν|τὸν|τήν|τὴν|οἱ|αἱ|τά|τὰ|τῶν|τοῖς|ταῖς|τούς|τοὺς|τάς|τὰς|τώ|τὼ|τοῖν|ταῖν) /i

  if entry.part_of_speech == :noun || entry.part_of_speech == :adjective
    return lemma.sub(regex, '')
  end

  lemma
end

def extract_gender_from_head_template(entry_json)
  gender_set = Set.new(['M', 'm', 'F', 'f'])
  head_template_json = entry_json['head_templates']
  return [] unless head_template_json.is_a?(Array)

  genders = []
  head_template_json.each do |template|
    args = template['args']
    next unless args.is_a?(Hash)

    genders += args.values.select { |a| gender_set.member?(a) }
  end

  genders
end

def build_dictionary(filename)
  dictionary = Dictionary.new

  File.foreach(filename) do |line|
    entry_json = JSON.parse(line)

    forms = entry_json['forms']
    next unless forms.is_a?(Array)

    headword = entry_json['word']
    part_of_speech = entry_json['pos']

    entry = dictionary.add_entry(headword, part_of_speech)

    genders = extract_gender_from_head_template(entry_json)
    table_level_tags = []

    forms.each do |variant_json|
      tags = variant_json['tags']
      next unless tags.is_a?(Array)

      next if tags.include?('romanization') ||
        tags.include?('inflection-template') ||
        tags.include?('canonical') ||
        tags.include?('alternative') ||
        tags.include?('class')

      if tags.include?('table-tags')
        table_level_tags = variant_json['form'].split
        next
      end

      lemma = variant_json['form']
      lemma = clean_up_definite_article(entry, lemma)
      next if lemma.nil? || lemma.strip.empty? || lemma == '-'

      if genders.empty?
        variant = entry.create_variant(lemma, tags: tags, forms: table_level_tags)
        variant.save!
      else
        genders.each do |gender|
          new_tags = tags + [gender]
          variant = entry.create_variant(lemma, tags: new_tags, forms: table_level_tags)
          variant.save!
        end
      end
    end

    word = entry_json['word']
    if entry.variants.empty? && !word.empty?
      variant = entry.create_variant(word)
      entry.create_variant(word).save!
    end

    entry.compact_and_update_dictionary!
  end

  dictionary
end
