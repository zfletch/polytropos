# Polytropos

Ancient Greek morphology tool based on Wiktionary data. This code is still
experimental and in development.

The code uses the English-language Wiktionary ancient Greek inflection tables
to match inflected forms with a headword and also generate inflected forms
for a given headword.

## Example usage

```ruby
load 'process.rb' 

d = build_dictionary('data/small.2025-09.jsonl')

d.look_up('ερωταομενη').map(&:to_s)
# => ["ἐρωτᾰομένη : verb singular present participle mediopassive feminine"] 

d.forms_of('λογος').last(3).map(&:to_s)
# => ["λόγε : noun singular masculine vocative",
#     "λόγω : noun dual masculine vocative",
#     "λόγοι : noun plural masculine vocative"]
```

## Downloading the data

The forms are ultimately from Wiktionary, but
[Wiktextract](https://github.com/tatuylonen/wiktextract) is used to extract them.

You can currently download the full ancient Greek data set by running:

```bash
curl https://kaikki.org/dictionary/Ancient%20Greek/kaikki.org-dictionary-AncientGreek.jsonl > data/full-wiktextract-data.jsonl
```

However, this may be deprecated in the near future.
