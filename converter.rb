#! /usr/bin/env ruby

require 'nokogiri'

directory = 'template/'

def parse_html(filename)
  directory = 'template/'
  return File.open(directory + filename) { |f| Nokogiri::HTML(f) }
end

def parse_fragment(filename)
  directory = 'template/'
  return Nokogiri::HTML::DocumentFragment.parse(File.read(directory + filename))
end

doc = parse_html('base.html')
fragment_masthead = parse_fragment('masthead.html')
fragment_content = parse_fragment('content.html')
fragment_article = parse_fragment('article.html')
fragment_imprint = parse_fragment('imprint.html')

node_content = doc.at('body').add_child(fragment_masthead).first.add_next_sibling(fragment_content).first
node_content.add_next_sibling(fragment_imprint)
node_content.add_child(fragment_article)

xsl = Nokogiri::XSLT(File.read(directory + 'pretty-printer.xsl'))
File.write('newsletter.html', xsl.apply_to(doc))
