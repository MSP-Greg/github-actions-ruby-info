# frozen_string_literal: true
# encoding: UTF-8

# Copyright (C) 2017 MSP-Greg

module Msys2Info

  YELLOW = "\e[33m"
  RESET = "\e[0m"

  PRE64 = /\Amingw-w64-x86_64-/
  PRE32 = /\Amingw-w64-i686-/

  class << self
    def run
      real_path = File.realpath "#{RbConfig::TOPDIR}/msys64"
      puts "Real path: #{real_path}"
      
      case ARGV[0]
      when 'utf-8'
        d4 = "\u2015".dup.force_encoding('utf-8') * 4
      when 'Windows-1252'
        d4 = 151.chr * 4
      else
        d4 = "\u2015".dup.force_encoding('utf-8') * 4
      end

      ary = `pacman.exe -Q"`

      hsh = ary.split(/[\r\n]+/).group_by { |e|
        case e
        when PRE32 then :i686
        when PRE64 then :x64
        else :msys2
        end
      }

      hsh[:x64]    = [] unless hsh[:x64]
      hsh[:msys2]  = [] unless hsh[:msys2]

      unless hsh[:x64].empty?
        highlight "\n#{d4 + ' mingw-w64-x86_64 Packages ' + d4}"
        len = hsh[:x64].length - 1
        0.upto(len) { |i|
          puts hsh[:x64][i].sub(PRE64, '')
        }
      end

      unless hsh[:msys2].empty?
        highlight "\n#{(d4 + ' MSYS2 Packages ' + d4).ljust(59)} #{d4} MSYS2 Packages #{d4}"
        half = hsh[:msys2].length/2.ceil
        0.upto(half -1) { |i|
          puts "#{(hsh[:msys2][i] || '').ljust(59)} #{hsh[:msys2][i + half] || ''}"
        }
      end
    end
    
    def highlight(str)
      str2 = str.dup
      while str2.sub!(/\A\n/, '') do ; puts ; end
      puts "#{YELLOW}#{str2}#{RESET}"
    end

  end
end
Msys2Info.run

exit 0
