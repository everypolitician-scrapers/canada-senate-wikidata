#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/Template:Senate_of_Canada',
  xpath: '//table//a[not(@class="new")]/@title',
)

# pick up any who have started or finished after 2015
# This won't get all long-serving members, but those should be in the Template
sparq = <<EOQ
  SELECT ?item WHERE {
    ?item p:P39 ?posn .
    ?posn ps:P39 wd:Q18524027 ; pq:P580 ?start .
    OPTIONAL { ?posn pq:P582 ?end }
    FILTER ((?start >= "2015-12-03T00:00:00Z"^^xsd:dateTime) ||  (?end >= "2015-12-03T00:00:00Z"^^xsd:dateTime))
  }
EOQ
ids = EveryPolitician::Wikidata.sparql(sparq)

EveryPolitician::Wikidata.scrape_wikidata(ids: ids, names: { en: names })
