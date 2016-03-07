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
		class TechnicalFindingsTemplate < Risu::Base::TemplateBase
			include TemplateHelper

			def initialize ()
				@template_info =
				{
					:name => "technical_findings",
					:author => "hammackj",
					:version => "0.0.9",
					:renderer => "PDF",
					:description => "Generates a Technical Findings NessusReport"
				}
			end

			def print_technical_findings(risks, text, color, last=false)
				if risks.length > 0
					title text, 18, color

					risks.each do |f|
						hosts = Item.where(:plugin_id => f.plugin_id).group(:host_id)
						plugin = Plugin.find_by_id(f.plugin_id)

						references = Reference.where(:plugin_id => plugin.id).group(:value).order(:reference_name)

						output.font_size(16) do
							text "#{plugin.plugin_name}\n"
						end

						if hosts.length > 1
							text "Hosts", :style => :bold
						else
							text "Host", :style => :bold
						end

						hostlist = Array.new
						hosts.each do |host|
							ho = Host.find_by_id(host.host_id)
							host_string = "#{ho.name}"
							host_string << " (#{ho.fqdn})" if ho.fqdn != nil
							hostlist << host_string
						end

						text hostlist.join(', ')

						definition "Plugin output", f.plugin_output
						definition "Description", plugin.description.gsub(/[ ]{2,}/, " ") if plugin.description != nil
						definition "Synopsis", plugin.synopsis
						definition "CVSS Base Score", plugin.cvss_base_score
						definition "Exploit Available", (plugin.exploit_available == "true") ? "Yes" : "No"
						definition "Solution", plugin.solution
						definition "References", plugin.references.reference_string, :inline_format => true

						plugin_url = "http://www.tenablesecurity.com/plugins/index.php?view=single&id=#{plugin.id}"
						definition "Nessus Plugin", plugin_url, :inline_format => true, :link => plugin_url

						text "\n"
					end

					@output.start_new_page if last == false
				end
			end

			def render(output)
				text NessusReport.classification.upcase, :align => :center
				text "\n"

				NessusReport_title NessusReport.title
				NessusReport_subtitle "Technical Findings"
				NessusReport_author "This NessusReport was prepared by\n#{NessusReport.author}"
				text "\n\n\n"

				# If you uncomment the med/low change the true in high to false for a new page after it

				print_technical_findings(Item.critical_risks_unique, "Critical Findings", Risu::GRAPH_COLORS[0]) if Item.critical_risks_unique.to_a.size != 0
				print_technical_findings(Item.high_risks_unique, "High Findings", Risu::GRAPH_COLORS[1], true) if Item.high_risks_unique.to_a.size != 0
				#print_technical_findings(Item.medium_risks_unique, "Medium Findings", Risu::GRAPH_COLORS[2]) if Item.medium_risks_unique.to_a.size != 0
				#print_technical_findings(Item.low_risks_unique, "Low Findings", Risu::GRAPH_COLORS[3], true) if Item.low_risks_unique.to_a.size != 0

				output.number_pages "<page> of <total>", :at => [output.bounds.right - 75, 0], :width => 150, :page_filter => :all
			end
		end
	end
end
