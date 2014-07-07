#
# Author:: Manas Alekar
# Author:: Bao Nguyen <ngqbao@gmail.com>
# Cookbook Name:: cumulus-linux
# Library:: ports
#
# Copyright 2014, Ooyala
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'json'

module Accton
  module AS6701_32X
    X_pipeline = [1,2,3,4,5,6,7,8,9,10,11,24,25,26,30,31,32]
    Y_pipeline = [12,13,14,15,16,17,18,19,20,21,22,23,27,28,29]
  end
end

module Cumulus
  class SwitchConfig

    def initialize(x=nil,y=nil)
      @ports = []
      x.each do |n|
        @ports << PortConfig.new(n,"x")
      end

      y.each do |n|
        @ports << PortConfig.new(n,"y")
      end
    end

    def [](n)
      @ports[n]
    end

    def port(n)
      @ports.each do |x|
        if x.id == n
          @ports[n]
        end
      end
    end

    def nports
      @ports.inject(0) { |acc, p| acc + p.nports }
    end

    def from_json
    end

    def to_pipeline
      ret = {}
      @ports.each do |n|
        ret[n.id] = n.pipeline
      end
      ret
    end

    def to_ports
      ret = {}
      @ports.each do |n|
        ret[n.id] = n.mode
      end
      ret
    end

    def to_json
      @ports.inject({}) { |acc, p| acc.merge(p.serialize) }.to_json
    end
  end

  class PortConfig

    attr_accessor :pipeline
    attr_accessor :id

    def initialize(id, pipeline)
      @id       = id
      @pipeline = pipeline
      @mode    = :c1x40g
      @unit   = [PortUnit.new]
    end

    def set1x40g
      @mode  = :c1x40g
      @unit = [PortUnit.new]
    end

    def set4x10g
      @mode  = :c4x10g
      @unit = []
      4.times do
        @unit << PortUnit.new
      end
    end

    def mode
      @mode == :c4x10g ? "4x10G" : "40G"
    end

    def nports
      @mode == :c1x40g ? 1 : 4
    end

    def serialize
      if @mode == :c1x40g
        {
          "swp#{@id}" => @unit[0].serialize
        }
      else
        ret = {}
        0.upto(3) do |n|
          ret["swp#{@id}s#{n}"] = @unit[n].serialize
        end
        ret
      end
    end

    def deserialize
    end

  end

  class PortUnit
    attr_accessor :ip

    def initialize
      @state = :up
    end

    def serialize
      { :state => @state }
    end

    def deserialize
    end
  end
end

if __FILE__ == $0
  conf = Cumulus::SwitchConfig.new(Accton::AS6701_32X::X_pipeline,Accton::AS6701_32X::Y_pipeline)
  conf[0].set4x10g
  puts conf.to_json

  (0..5).each do |i|
    puts "#{i} - #{conf[i].id}:#{conf[i].pipeline}"
  end

  puts conf.to_pipeline

  puts conf.to_ports

  puts conf.nports
end
