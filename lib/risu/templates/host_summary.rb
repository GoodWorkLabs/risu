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
	module Templates
		class HostSummary < Risu::Base::TemplateBase
			include TemplateHelper

			#
			def initialize ()
				@template_info =
				{
					:name => "host_summary",
					:author => "hammackj",
					:version => "0.0.3",
					:renderer => "PDF",
					:description => "Generates a Host Summary Report"
				}
			end

			#
			#
			def render(output)
				@output.text Report.classification.upcase, :align => :center
				@output.text "\n"

				report_title Report.title
				report_subtitle "Host Summary Report"
				report_author "This report was prepared by\n#{Report.author}"

				@output.text "\n\n\n"

				@output.text "Scan Date:", :style => :bold
				@output.text "#{Report.scan_date}"
				@output.text "\n"

				results = Array.new

				headers = ["Hostname", "Total", "Critical", "High", "Medium", "Low", "Info"]
				header_widths = {0 => 230, 1 => 46, 2 => 46, 3 => 46, 4 => 47, 5 => 46, 6 => 46}

				Host.sorted.each do |host|
					row = Array.new

					total  = Item.risks.where(:host_id => host.id).count
					crit = Item.critical_risks.where(:host_id => host.id).count
					high = Item.high_risks.where(:host_id => host.id).count
					medium = Item.medium_risks.where(:host_id => host.id).count
					low = Item.low_risks.where(:host_id => host.id).count
					info = Item.info_risks.where(:host_id => host.id).count

					host_name = host.name
					host_name = "#{host.name} (#{host.netbios})" if host.netbios != nil

					row.push(host_name)
					row.push(total)
					row.push(crit)
					row.push(high)
					row.push(medium)
					row.push(low)
					row.push(info)

					results.push(row)
				end

				output.table([headers] + results, :header => true, :column_widths => header_widths, :row_colors => ['ffffff', 'E5E5E5']) do
					row(0).style(:font_style => :bold, :background_color => 'D0D0D0')
					cells.borders = [:top, :bottom, :left, :right]
				end

				output.number_pages "<page> of <total>", :at => [output.bounds.right - 75, 0], :width => 150, :page_filter => :all
			end
		end
	end
end
