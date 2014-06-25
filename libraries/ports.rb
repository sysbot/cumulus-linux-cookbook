#
# Author:: Bao Nguyen <ngqbao@gmail.com>
# Cookbook Name:: cumulus-linux
# Library:: ports
#
# Copyright 2014, Bao Nguyen
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

module Cumulus
  module AS6701_32X
    X = [1,2,3,4,5,6,7,8,9,10,11,24,25,26,30,31,32]
    Y = [12,13,14,15,16,17,18,19,20,21,22,23,27,28,29]
    class Ports
      attr_accessor :ports

      def initialize()
        @ports = Array.new(32) {|i| i="40G"}
      end

      def set_10G(index)
        @ports[index] = "4x10G"
      end

      def set_40G(index)
        @ports[index] = "4x10G"
      end

      def get_x()
        Cumulus::AS6701_32X::X
      end

      def get_y()
        Cumulus::AS6701_32X::Y
      end
    end
  end
end
