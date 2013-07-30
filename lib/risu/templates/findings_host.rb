# Copyright (c) 2010-2013 Arxopia LLC.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Arxopia LLC nor the names of its contributors
#     	may be used to endorse or promote products derived from this software
#     	without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ARXOPIA LLC BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
#OF THE POSSIBILITY OF SUCH DAMAGE.

module Risu
	module Templates
		class FindingsHost < Risu::Base::TemplateBase

			#
			#
			def initialize ()
				@template_info =
				{
					:name => "findings_host",
					:author => "hammackj",
					:version => "0.0.2",
					:description => "Generates a findings report by host"
				}
			end

			#
			#
			def render(output)
				output.font_size 10

				output.text Report.classification.upcase, :align => :center
				output.text "\n"

				output.font_size(22) { output.text Report.title, :align => :center }
				output.font_size(18) {
					output.text "Findings Summary by Host Report", :align => :center
					output.text "\n"
					output.text "This report was prepared by\n#{Report.author}", :align => :center
				}

				output.text "\n\n\n"

				Host.sorted.each do |host|
					if host.items.high_risks_unique_sorted.to_a.count > 0 or host.items.medium_risks_unique_sorted.to_a.count > 0
						output.font_size(16) do

							host_string = "#{host.ip}"
							host_string << " (#{host.fqdn})" if host.fqdn != nil

							output.text "#{host_string}", :style => :bold
						end
					end

					if host.items.critical_risks_unique_sorted.to_a.count > 0
						output.font_size(12) do
							output.fill_color "551A8B"
							output.text "Critical Findings", :style => :bold
							output.fill_color "000000"
						end

						host.items.high_risks_unique_sorted.each do |item|
							name = Plugin.find_by_id(item.plugin_id).plugin_name
							output.text "#{name}"
						end
					end

					if host.items.high_risks_unique_sorted.to_a.count > 0
						output.font_size(12) {
							output.fill_color "FF0000"
							output.text "High Findings", :style => :bold
							output.fill_color "000000"
						}

						host.items.high_risks_unique_sorted.each do |item|
							name = Plugin.find_by_id(item.plugin_id).plugin_name
							output.text "#{name}"
						end
					end

					if host.items.medium_risks_unique_sorted.to_a.count > 0
						output.font_size(12) {
							output.fill_color "FF8040"
							output.text "Medium Findings", :style => :bold
							output.fill_color "000000"
						}

						host.items.medium_risks_unique_sorted.each do |item|
							name = Plugin.find_by_id(item.plugin_id).plugin_name
							output.text "#{name}"
						end
					end

					if host.items.high_risks_unique_sorted.to_a.count > 0 or host.items.medium_risks_unique_sorted.to_a > 0
						output.text "\n"
					end
				end

			end
		end
	end
end
