#--
# EDTF-Ruby
# Copyright 2011 Sylvester Keil. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#  1. Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
# 
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
# NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# The views and conclusions contained in the software and documentation are
# those of the authors and should not be interpreted as representing official
# policies, either expressed or implied, of the copyright holder.
#++

require 'date'
autoload :Rational, 'rational'

require 'forwardable'

require 'edtf/compatibility'

require 'edtf/version'
require 'edtf/uncertainty'
require 'edtf/seasons'
require 'edtf/date'
require 'edtf/date_time'
require 'edtf/interval'
require 'edtf/parser'
require 'edtf/extensions'

# = EDTF-Ruby
#
# This module extends the Ruby date/time classes to support the Extended
# Date/Time Format (EDTF). See the `EDTF::ExtendedDate` module for an
# overview of the features added to the Ruby `Date` class.
#
# To parse EDTF strings use either `Date.edtf` of `EDTF.parse`.
#
module EDTF
  
  def parse(input, options = {})
    ::Date.edtf(input, options)
  end
  
  module_function :parse
  
end