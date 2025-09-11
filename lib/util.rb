module Util
  DIACRITICS = /[\u0300\u0301\u0342\u0313\u0314\u0308\u0345]/
  LENGTH_MARKERS = /[\u0304\u0306]/

  def self.standard_form(string)
    string
      .unicode_normalize(:nfd)
      .gsub(Util::LENGTH_MARKERS, '')
      .unicode_normalize(:nfc)
  end

  def self.bare_form(string)
    string
      .unicode_normalize(:nfd)
      .gsub(Util::LENGTH_MARKERS, '')
      .gsub(Util::DIACRITICS, '')
      .unicode_normalize(:nfc)
  end
end
