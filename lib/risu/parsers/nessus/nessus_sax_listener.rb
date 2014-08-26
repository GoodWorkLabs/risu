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

ActiveRecord::Migration.verbose = false

module Risu
	module Parsers
		module Nessus

			# NessusSaxListener
			class NessusSaxListener
				include LibXML::XML::SaxParser::Callbacks

				# Sets up a array of all valid XML fields
				def initialize
					@vals = Hash.new

					@valid_references = Array[
						"cpe", "bid", "see_also", "xref", "cve", "iava", "msft",
						"osvdb", "cert", "edb-id", "rhsa", "secunia", "suse", "dsa",
						"owasp", "cwe", "iavb", "iavt", "cisco-sa", "ics-alert",
						"cisco-bug-id", "cisco-sr", "cert-vu", "vmsa", "apple-sa",
						"icsa", "cert-cc", "msvr", "usn", "hp", "glsa", "freebsd"
					]

					@valid_host_properties = Array[
						"HOST_END", "mac-address", "HOST_START", "operating-system", "host-ip", "host-fqdn", "netbios-name",
						"local-checks-proto", "smb-login-used", "ssh-auth-meth", "ssh-login-used", "pci-dss-compliance",
						"pci-dss-compliance:", "system-type", "bios-uuid", "pcidss:compliance:failed", "pcidss:compliance:passed",
						"pcidss:deprecated_ssl", "pcidss:expired_ssl_certificate", "pcidss:high_risk_flaw", "pcidss:medium_risk_flaw",
						"pcidss:reachable_db", "pcidss:www:xss", "pcidss:directory_browsing", "pcidss:known_credentials",
						"pcidss:compromised_host:worm", "pcidss:obsolete_operating_system", "pcidss:dns_zone_transfer",
						"pcidss:unprotected_mssql_db", "pcidss:obsolete_software", "pcidss:www:sql_injection", "pcidss:backup_files",
						"traceroute-hop-0", "traceroute-hop-1", "traceroute-hop-2", "operating-system-unsupported", "patch-summary-total-cves",
						"pcidss:insecure_http_methods", "LastUnauthenticatedResults", "LastAuthenticatedResults", "cpe-0", "cpe-1", 
						"cpe-2", "cpe-3", "Credentialed_Scan", "policy-used", "UnsupportedProduct:microsoft:windows_xp::sp2"
					]

					@valid_host_properties_regex = Array[
						"patch-summary-cve-num", "patch-summary-cves", "patch-summary-txt", "cpe-\d+", "KB\d+"
					]

					@valid_elements = Array["ReportItem", "plugin_version", "risk_factor",
						"description", "cvss_base_score", "solution", "item", "plugin_output", "tag", "synopsis", "plugin_modification_date",
						"FamilyName", "FamilyItem", "Status", "vuln_publication_date", "ReportHost", "HostProperties", "preferenceName",
						"preferenceValues", "preferenceType", "fullName", "pluginId", "pluginName", "selectedValue", "selectedValue",
						"name", "value", "preference", "plugin_publication_date", "cvss_vector", "patch_publication_date",
						"NessusClientData_v2", "Policy", "PluginName", "ServerPreferences", "policyComments", "policyName", "PluginItem",
						"Report", "Family", "Preferences", "PluginsPreferences", "FamilySelection", "IndividualPluginSelection", "PluginId",
						"pci-dss-compliance", "exploitability_ease", "cvss_temporal_vector", "exploit_framework_core", "cvss_temporal_score",
						"exploit_available", "metasploit_name", "exploit_framework_canvas", "canvas_package", "exploit_framework_metasploit",
						"plugin_type", "exploithub_sku", "exploit_framework_exploithub", "stig_severity", "plugin_name", "fname", "always_run",
						"cm:compliance-info", "cm:compliance-actual-value", "cm:compliance-check-id", "cm:compliance-policy-value",
						"cm:compliance-audit-file", "cm:compliance-check-name", "cm:compliance-result", "cm:compliance-output", "policyOwner",
						"visibility", "script_version", "attachment", "policy_comments", "d2_elliot_name", "exploit_framework_d2_elliot",
						"exploited_by_malware", "compliance"
					]

					@valid_elements = @valid_elements + @valid_references

					# These are the more commonly used host properties, mapping them here to store in the host table
					@host_properties_mapping = {
						"HOST_END" => :end,
						"mac-address" => :mac,
						"HOST_START" => :start,
						"operating-system" => :os,
						"host-ip" => :ip,
						"host-fqdn" => :fqdn,
						"netbios-name" => :netbios
					}
				end

				# Callback for when the start of a XML element is reached
				#
				# @param element XML element
				# @param attributes Attributes for the XML element
				def on_start_element(element, attributes)
					@tag = element
					@vals[@tag] = ""

					if !@valid_elements.include?(element)
						puts "New XML element detected: #{element}. Please report this at #{Risu::GITHUB}/issues/new or via email to #{Risu::EMAIL}"
					end

					case element
						when "Policy"
							@policy = Risu::Models::Policy.create
							@policy.save
						when "preference"
							@sp = @policy.server_preferences.create
							@sp.save
						when "item"
							@item = @policy.plugins_preferences.create
							@item.save
						when "FamilyItem"
							@family = @policy.family_selections.create
							@family.save
						when "PluginItem"
							@plugin_selection = @policy.individual_plugin_selections.create
							@plugin_selection.save
						when "Report"
							@report = @policy.reports.create
							@report.name = attributes["name"]
							@report.save
						when "ReportHost"
							@rh = @report.hosts.create
							@rh.name = attributes["name"]
							@rh.save
						when "tag"
							@attr = nil
							@hp = @rh.host_properties.create

							if attributes["name"] =~ /[M|m][S|s]\d{2,}-\d{2,}/
								@attr = if attributes["name"] =~ /[M|m][S|s]\d{2,}-\d{2,}/
											attributes["name"]
										else
											nil
										end
							#Ugly as fuck. Really this needs to be rewritten. Fuck.
							elsif attributes['name'] =~ /patch-summary-cve-num/ ||
								attributes['name'] =~ /patch-summary-cves/ ||
								attributes['name'] =~ /patch-summary-txt/ ||
								attributes['name'] =~ /cpe-\d+/ ||
								attributes['name'] =~ /KB\d+/
								@attr = if attributes["name"] =~ /patch-summary-cve-num/ ||
								attributes['name'] =~ /patch-summary-cves/ ||
								attributes['name'] =~ /patch-summary-txt/ ||
								attributes['name'] =~ /cpe-\d+/ ||
								attributes['name'] =~ /KB\d+/
											attributes["name"]
										else
											nil
										end
							else
								@attr = if @valid_host_properties.include?(attributes["name"])
									attributes["name"]
								else
									nil
								end
							end

							# implicit nil check?
							if attributes["name"] !~ /(netstat-(?:established|listen)-(?:tcp|udp)\d+-\d+)/ && attributes["name"] !~ /traceroute-hop-\d+/
								puts "New HostProperties attribute: #{attributes["name"]}. Please report this at #{Risu::GITHUB}/issues/new or via email to #{Risu::EMAIL}\n" if @attr.nil?
							end
						when "ReportItem"
							@vals = Hash.new # have to clear this out or everything has the same references
							@ri = @rh.items.create
							if attributes["pluginID"] == "0"
								@plugin = Risu::Models::Plugin.find_or_create_by(:id => 1)
							else
								@plugin = Risu::Models::Plugin.find_or_create_by(:id => attributes["pluginID"])
							end

							@ri.port = attributes["port"]
							@ri.svc_name = attributes["svc_name"]
							@ri.protocol = attributes["protocol"]
							@ri.severity = attributes["severity"]

							@ri.plugin_id = @plugin.id
							@plugin.plugin_name = attributes["pluginName"]
							@plugin.family_name = attributes["pluginFamily"]
							@plugin.save
							@ri.save
						when "attachment"
							@attachment = @ri.attachments.create
							@attachment.name = attributes['name']
							@attachment.type = attributes['type']
							@attachment.save
					end
				end

				# Called when the inner text of a element is reached
				#
				# @param text
				def on_characters(text)
					if @vals[@tag] == nil then
						@vals[@tag] = text
					else
						@vals[@tag] << text
					end
				end

				# Called when the end of the XML element is reached
				#
				# @param element
				def on_end_element(element)
					@tag = nil
					case element
						when "policyName"
							@policy.attributes = {
								:name => @vals["policyName"]
							}
							@policy.save

						when "policyComments"
							@policy.attributes = {
								:comments => @vals["policyComments"]
							}
							@policy.save

						when "policy_comments"
							@policy.attributes = {
								:comments => @vals["policy_comments"]
							}
							@policy.save

						when "policyOwner"
							@policy.attributes = {
								:owner => @vals["policyOwner"]
							}
							@policy.save

						when "visibility"
							@policy.attributes = {
								:visibility => @vals["visibility"]
							}
							@policy.save

						when "preference"
							@sp.attributes = {
								:name => @vals["name"],
								:value => @vals["value"]
							}
							@sp.save

							#This takes a really long time, there is about 34,000 pluginIDs in this
							#field and it takes about 36 minutes to parse just this info =\
							#lets pre-populate the plugins table with the known plugin_id's
							#if @vals["name"] == "plugin_set"
							#	 @all_plugins = @vals["value"].split(";")
							#
							#	 @all_plugins.each { |p|
							#			@plug = Plugin.find_or_create_by_id(p)
							#			@plug.save
							#	 }
							#end
						when "item"
							@item.attributes = {
								:plugin_name => @vals["pluginName"],
								:plugin_id => @vals["pluginId"],
								:fullname => @vals["fullName"],
								:preference_name => @vals["preferenceName"],
								:preference_type => @vals["preferenceType"],
								:preference_values => @vals["preferenceValues"],
								:selected_values => @vals["selectedValue"]
							}

							@item.save
						when "FamilyItem"
							@family.attributes = {
								:family_name => @vals["FamilyName"],
								:status => @vals["Status"]
							}

							@family.save
						when "PluginItem"
							@plugin_selection.attributes = {
								:plugin_id => @vals["PluginId"],
								:plugin_name => @vals["PluginName"],
								:family => @vals["Family"],
								:status => @vals["Status"]
							}

							@plugin_selection.save
						when "tag"
							if @attr =~ /[M|m][S|s]\d{2}-\d{2,}/
								@patch = @rh.patches.create
								@patch.name = @attr
								@patch.value = @vals['tag']
								@patch.save
							else
								@rh.attributes = {@host_properties_mapping[@attr] => @vals["tag"].gsub("\n", ",") } if @host_properties_mapping.keys.include?(@attr)
								@rh.save

								@hp.name = @attr
								@hp.value = @vals['tag']
								@hp.save

							end if @attr != nil
						#We cannot handle the references in the same block as the rest of the ReportItem tag because
						#there tends to be more than of the different types of reference per ReportItem, this causes issue for a sax
						#parser. To solve this we do the references before the final plugin data, Valid references must be added
						#the @valid_reference array at the top to be parsed.
						# *@valid_reference, does a 'when' on each element of the @valid_references array, pure magic
						when *@valid_references
							@ref = @plugin.references.create
							@ref.reference_name = element
							@ref.value = @vals["#{element}"]
							@ref.save
						when "ReportItem"
							@ri.plugin_output = @vals["plugin_output"]
							@ri.plugin_name = @vals["plugin_name"]
							@ri.cm_compliance_info = @vals["cm:compliance-info"]
							@ri.cm_compliance_actual_value = @vals["cm:compliance-actual-value"]
							@ri.cm_compliance_check_id = @vals["cm:compliance-check-id"]
							@ri.cm_compliance_policy_value= @vals["cm:compliance-policy-value"]
							@ri.cm_compliance_audit_file = @vals["cm:compliance-audit-file"]
							@ri.cm_compliance_check_name = @vals["cm:compliance-check-name"]
							@ri.cm_compliance_result = @vals["cm:compliance-result"]
							@ri.cm_compliance_output = @vals["cm:compliance-output"]

							@ri.save

							@plugin.attributes = {
								:solution => @vals["solution"],
								:risk_factor => @vals["risk_factor"],
								:description => @vals["description"],
								:plugin_publication_date => @vals["plugin_publication_date"],
								:plugin_modification_date => @vals["plugin_modification_date"],
								:synopsis => @vals["synopsis"],
								:plugin_type => @vals["plugin_type"],
								:cvss_vector => @vals["cvss_vector"],
								:cvss_base_score => @vals["cvss_base_score"].to_f,
								:vuln_publication_date => @vals["vuln_publication_date"],
								:plugin_version => @vals["plugin_version"],
								:cvss_temporal_score => @vals["cvss_temporal_score"],
								:cvss_temporal_vector => @vals["cvss_temporal_vector"],
								:exploitability_ease => @vals["exploitability_ease"],
								:exploit_framework_core => @vals["exploit_framework_core"],
								:exploit_available => @vals["exploit_available"],
								:exploit_framework_metasploit => @vals["exploit_framework_metasploit"],
								:metasploit_name => @vals["metasploit_name"],
								:exploit_framework_canvas => @vals["exploit_framework_canvas"],
								:canvas_package => @vals["canvas_package"],
								:exploit_framework_exploithub => @vals["exploit_framework_exploithub"],
								:exploithub_sku => @vals["exploithub_sku"],
								:stig_severity => @vals["stig_severity"],
								:fname => @vals["fname"],
								:always_run => @vals["always_run"],
								:script_version => @vals["script_version"],
								:exploited_by_malware => @vals["exploited_by_malware"],
								:compliance => @vals["compliance"]
							}
							@plugin.save
						when "attachment"
							@attachment.attributes = {
								:ahash => @vals['attachment']
							}
							@attachment.save
					end
				end
			end
		end
	end
end
