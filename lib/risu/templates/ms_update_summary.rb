# Copyright (c) 2010-2014 Arxopia LLC.
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
	module Templates
		class MSUpdateSummary < Risu::Base::TemplateBase

			#
			#
			def initialize ()
				@template_info =
				{
					:name => "ms_update_summary",
					:author => "hammackj",
					:version => "0.0.2",
					:renderer => "PDF",
					:description => "Generates a Microsoft Update Summary Report"
				}
			end

			#
			#
			def render(output)
				output.text Report.classification.upcase, :align => :center
				output.text "\n"

				output.font_size(22) { output.text Report.title, :align => :center }
				output.font_size(18) {
					output.text "Microsoft Update Summary", :align => :center
					output.text "\n"
					output.text "This report was prepared by\n#{Report.author}", :align => :center
				}

				output.text "\n\n\n"

				output.font_size(12)

				results = Array.new

				headers = ["Hostname","Operating System", "Windows Update Status"]
				header_widths = {0 => 108, 1 => 264, 2 => 140}

				Item.ms_update.each do |item|
					host = Host.find_by_id(item.host_id)

					if host == nil
						next
					end

					row = Array.new
					row.push(host.name)
					row.push(host.os)

					if item.plugin_output =~ /'Automatic Updates' are disabled/
						row.push("Disabled")
					else
						row.push("Enabled")
					end

					results.push(row)
				end

				output.table([headers] + results, :header => true, :column_widths => header_widths, :row_colors => ['FFFFFF', '336699']) do
					row(0).style(:font_style => :bold, :background_color => 'CCCCCC')
					cells.borders = [:top, :bottom, :left, :right]
				end

			end
		end
	end
end
