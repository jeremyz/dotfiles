#! /usr/bin/env ruby

require 'time'

YEAR = (Time.new.year - 1).to_s.freeze
BASE = '/home/jeyzu/usr/private/mail'.freeze
BOXES = %w[admin ardour asynk corina efl family friends hydrogen inaxis zedem].freeze

FLAGS = { draft: /D/, seen: /S/, flagged: /F/, replied: /R/, thrashed: /T/ }.freeze
def _flags(fname)
  flags = fname.match(/.*:2,(.+)$/).captures[0]
  FLAGS.transform_values { |v| !(flags =~ v).nil? }
end

def _from(content)
  from = content.match(/^From: (.*)$/).captures[0]
  m = from.match('<(.*)>')
  return from if m.nil?

  m.captures[0]
end

def _date(content)
  Time.parse(content.match(/^[Dd]ate: (.*)$/).captures[0])
end

ENC = [nil, 'iso-8859-1'].freeze
def _content(fpath)
  ENC.each do |enc|
    begin
      return File.read(fpath) if enc.nil?

      return File.read(fpath, encoding: enc).encode('utf-8')
    rescue ArgumentError
      puts ''
    rescue EncodingError
      puts ''
    end
  end
  nil
end

Dir.chdir(BASE)
BOXES.each do |mbox|
  # puts "\n *** #{mbox}"
  out_path = "#{BASE}/archives/#{mbox}-#{YEAR}"
  fout = File.open(out_path, 'w:utf-8')
  Dir["./#{mbox}/cur/*"].each do |fpath|
    fname = fpath.match(%r{.*/(.*)}).captures[0]
    content = _content(fpath)
    next if content.nil?

    from = _from(content)
    date = _date(content)
    flags = _flags(fname)
    next if flags[:flagged] || date.strftime('%Y') != YEAR

    status = 'O' # 'cur'
    status += 'R' if flags[:seen]
    xstatus = flags[:replied] ? 'A' : nil
    fout << "From #{from} #{date.strftime('%a %b %d %H:%M:%S %Y')}\nStatus: #{status}\n"
    fout << "X-Status: #{xstatus}\n" unless xstatus.nil?
    fout << content
    fout << "\n"
    File.delete(fpath)
  end
  rm = fout.empty?
  fout.close
  File.delete(out_path) if rm
end
