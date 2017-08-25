#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/Template:Senate_of_Canada',
  xpath: '//table//li//a[not(@class="new")]/@title',
)

# pick up any who are no longer active (and thus not in template)
sparq = <<EOQ
  SELECT ?item WHERE {
    ?item p:P39 ?posn .
    ?posn ps:P39 wd:Q18524027 ; pq:P582 ?end .
    FILTER (?end >= "2015-12-03T00:00:00Z"^^xsd:dateTime) .
  }
EOQ
exmembers = EveryPolitician::Wikidata.sparql(sparq)

EveryPolitician::Wikidata.scrape_wikidata(ids: exmembers, names: { en: names })
