class Lemma
  POSTAG_MAP = { # Hash is ordered in Ruby
    part_of_speech: {
      noun: 'n',
      verb: 'v',
      adjective: 'a',
      adverb: 'd',
      article: 'l',
      particle: 'g',
      conjuncton: 'c',
      adposition: 'r',
      pronoun: 'p',
      number: 'm',
      interjection: 'i',
    },
    person: {
      first: '1',
      second: '2',
      third: '3',
    },
    number: {
      singular: 's',
      dual: 'd',
      plural: 'p',
    },
    tense: {
      present: 'p',
      imperfect: 'i',
      perfect: 'r',
      pluperfect: 'l',
      future_perfect: 't',
      future: 'f',
      aorist: 'a',
    },
    mood: {
      indicative: 'i',
      subjunctive: 's',
      optative: 'o',
      infinitive: 'n',
      imperative: 'm',
      particle: 'p',
    },
    voice: {
      active: 'a',
      passive: 'p',
      middle: 'm',
      mediopassive: 'e',
    },
    gender: {
      masculine: 'm',
      feminine: 'f',
      neuter: 'n',
    },
    casus: { # `case` is a keyword in Ruby
      nominative: 'n',
      genitive: 'g',
      dative: 'd',
      accusative: 'a',
      vocative: 'v',
    },
    degree: {
      comparative: 'c',
      superlative: 's',
    },
  }

  PERSON_MAP = {
    'first-person' => :first,
    'second-person' => :second,
    'third-person' => :third,
  }

  NUMBER_MAP = {
    'singular' => :singular,
    'dual' => :dual,
    'plural' => :plural,
  }

  TENSE_MAP = {
    'present' => :present,
    'imperfect' => :imperfect,
    'future' => :future,
    # 'future', 'perfect' => :future_perfect,
    'aorist' => :aorist,
    'perfect' => :perfect,
    'pluperfect' => :pluperfect,
  }

  MOOD_MAP = {
    'indicative' => :indicative,
    'imperative' => :imperative,
    'optative' => :optative,
    'subjunctive' => :subjunctive,

    # Not technically moods, but they go in the POStag's mood slot
    'infinitive' => :infinitive,
    'participle' => :participle,
  }

  VOICE_MAP = {
    'active' => :active,
    'passive' => :passive,
    'middle' => :middle,
    # 'middle', 'passive' => :mediopassive,
  }

  GENDER_MAP = {
    'masculine' => :masculine,
    'm' => :masculine,
    'M' => :masculine,

    'feminine' => :feminine,
    'f' => :feminine,
    'F' => :feminine,

    'neuter' => :neuter,
    'n' => :neuter,
    'N' => :neuter,
  }

  CASUS_MAP = {
    'nominative' => :nominative,
    'vocative' => :vocative,
    'accusative' => :accusative,
    'genitive' => :genitive,
    'dative' => :dative,
  }

  DEGREE_MAP = {
    'comparative' => :comparative,
    'superlative' => :superlative,
  }

  attr_reader :lemma
  attr_reader :part_of_speech, :person, :number, :tense, :mood, :voice, :gender,
    :casus, :degree

  def initialize(lemma, part_of_speech, tags: [], forms: [])
    @lemma = lemma

    @part_of_speech = part_of_speech
    tenses = Set.new(forms.map { |f| Lemma::TENSE_MAP[f] }.compact)
    if tenses.member?(:future) && tenses.member?(:perfect)
      @tense = :future_perfect
    else
      @tense = tenses.first
    end


    voices = Set.new
    tags.each do |tag|
      voices.add(Lemma::VOICE_MAP[tag]) if Lemma::VOICE_MAP[tag]

      @person ||= Lemma::PERSON_MAP[tag]
      @number ||= Lemma::NUMBER_MAP[tag]
      @mood ||= Lemma::MOOD_MAP[tag]
      @gender ||= Lemma::GENDER_MAP[tag]
      @casus ||= Lemma::CASUS_MAP[tag]
      @degree ||= Lemma::DEGREE_MAP[tag]
    end

    if voices.member?(:middle) && voices.member?(:passive)
      @voice = :mediopassive
    else
      @voice = voices.first
    end

    if mood == :participle && number.nil?
      @number = :singular
    end
  end

  def postag
    Lemma::POSTAG_MAP.map { |n, m| m[self.public_send(n)] || '-' }.join('')
  end

  def to_s
    [
      lemma,
      ':',
      part_of_speech,
      person,
      number,
      tense,
      mood,
      voice,
      gender,
      casus,
      degree,
    ].compact.join(' ')
  end
end
