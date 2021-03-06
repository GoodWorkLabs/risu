# Copyright (c) 2010-2016 Arxopia LLC.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Arxopia LLC nor the names of its contributors
#     	may be used to endorse or promote products derived from this software
#     	without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ARXOPIA LLC BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

module Risu
	module Parsers
		module Nessus
			module PostProcess
				class Java < Risu::Base::PostProcessBase

					#
					def initialize
						@info =
						{
							:description => "Java Patch Rollup",
							:plugin_id => -99999,
							:plugin_name => "Update to the latest Java",
							:item_name => "Update to the latest Java",
							:plugin_ids => [
								66932,
								65995,
								56959,
								59462,
								62593,
								45544,
								45379,
								65050,
								63521,
								65052,
								49996,
								52002,
								54997,
								55958,
								56566,
								57290,
								57959,
								64454,
								64790,
								76532,
								73570,
								70472,
								71966,
								61746,
								42373,
								36034,
								40495,
								23931,
								25370,
								24022,
								26923,
								35030,
								31356,
								65048,
								33488,
								78481,
								80908,
								82820,
								25124,
								25627,
								25903,
								31344,
								33487,
								25693,
								30148,
								61681,
								84824,
								33486,
								25709,
								

							]
						}
					end
				end
			end
		end
	end
end
