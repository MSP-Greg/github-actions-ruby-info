# frozen_string_literal: true

require 'psych'

obj = { 'foo': nil, 'bar': [nil] }
puts obj.to_yaml.tr(' ', '_')
puts '', Psych.load(obj.to_yaml)
