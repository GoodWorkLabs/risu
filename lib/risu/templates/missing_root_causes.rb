# Copyright (c) 2010-2015 Arxopia LLC.
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
		class MissingRootCauses < Risu::Base::TemplateBase

			#
			#
			def initialize ()
				@template_info =
				{
					:name => "missing_root_causes",
					:author => "hammackj",
					:version => "0.0.1",
					:renderer => "PDF",
					:description => "Generates a Report of all the findings without a root cause"
				}
			end

			#
			#
			def render(output)
				output.text Report.classification.upcase, :align => :center
				output.text "\n"

				output.font_size(22) do
					output.text Report.title, :align => :center
				end

				output.font_size(18) do
					output.text "Missing Root Causes Report", :align => :center
					output.text "\n"
					output.text "This report was prepared by\n#{Report.author}", :align => :center
				end

				output.text "\n\n\n"

				output.font_size(20) {
					output.fill_color "9B30FF"
					output.text "Critical Findings", :style => :bold
					output.fill_color "000000"
				}

				Item.critical_risks_unique_sorted.each do |item|
					plugin = Plugin.find_by_id(item.plugin_id)
					name = Plugin.find_by_id(item.plugin_id).plugin_name
					count = Item.where(:plugin_id => item.plugin_id).count

					if plugin.root_cause != nil
						next
					end

					output.text "#{count} - #{name} - #{item.plugin_id}" 
				end

				output.start_new_page

				output.font_size(20) do
					output.fill_color "FF0000"
					output.text "High Findings", :style => :bold
					output.fill_color "000000"
				end

				Item.high_risks_unique_sorted.each do |item|
					plugin = Plugin.find_by_id(item.plugin_id)
					name = Plugin.find_by_id(item.plugin_id).plugin_name
					count = Item.where(:plugin_id => item.plugin_id).count

					if plugin.root_cause != nil
						next
					end					

					output.text "#{count} - #{name} - #{item.plugin_id}"
				end

				output.start_new_page

				output.font_size(20) {
					output.fill_color "FF8040"
					output.text "Medium Findings", :style => :bold
					output.fill_color "000000"
				}

				Item.medium_risks_unique_sorted.each do |item|
					plugin = Plugin.find_by_id(item.plugin_id)
					name = Plugin.find_by_id(item.plugin_id).plugin_name
					count = Item.where(:plugin_id => item.plugin_id).count

					if plugin.root_cause != nil
						next
					end

					output.text "#{count} - #{name} - #{item.plugin_id}"
				end

				output.start_new_page

				output.font_size(20) {
					output.fill_color "0000FF"
					output.text "Low Findings", :style => :bold
					output.fill_color "000000"
				}

				Item.low_risks_unique_sorted.each do |item|
					plugin = Plugin.find_by_id(item.plugin_id)
					name = Plugin.find_by_id(item.plugin_id).plugin_name
					count = Item.where(:plugin_id => item.plugin_id).count

					if plugin.root_cause != nil
						next
					end

					output.text "#{count} - #{name} - #{item.plugin_id}"
				end

				output.start_new_page

				output.font_size(20) {
					output.fill_color "008000"
					output.text "Info Findings", :style => :bold
					output.fill_color "000000"
				}
				
				Item.info_risks_unique_sorted.each do |item|
					plugin = Plugin.find_by_id(item.plugin_id)
					name = Plugin.find_by_id(item.plugin_id).plugin_name
					count = Item.where(:plugin_id => item.plugin_id).count

					if plugin.root_cause != nil
						next
					end
				
					output.text "#{count} - #{name} - #{item.plugin_id}"
				end
			end
		end
	end
end
