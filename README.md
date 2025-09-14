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

d.look_up('ερωταομενη')
# => [ἐρωτᾰομένη : verb singular present participle mediopassive feminine nominative]

d.forms_of('λογος').first(3)
# => [λόγος : noun singular masculine nominative,
#     λόγω : noun dual masculine nominative,
#     λόγοι : noun plural masculine nominative]
```

## Downloading the data

The forms are ultimately from Wiktionary, but
[Wiktextract](https://github.com/tatuylonen/wiktextract) is used to extract them.

You can currently download the full ancient Greek data set by running:

```bash
curl https://kaikki.org/dictionary/Ancient%20Greek/kaikki.org-dictionary-AncientGreek.jsonl > data/full-wiktextract-data.jsonl
```

However, this may be deprecated in the near future.
