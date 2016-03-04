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
	module Base

		# Risu database Schema
		class Schema < ActiveRecord::Migration

			# Creates all of the database tables required by the parser
			def self.up
				create_table :risu_policies do |t|
					t.string :name
					t.text :comments
					t.string :owner
					t.string :visibility
				end

				create_table :risu_server_preferences do |t|
					t.integer :policy_id
					t.string :name
					t.text :value, limit: 4294967295
				end

				create_table :risu_plugins_preferences do |t|
					t.integer :policy_id
					t.integer :plugin_id
					t.string :plugin_name
					t.string :fullname
					t.string :preference_name
					t.string :preference_type
					t.string :preference_values
					t.string :selected_values
				end

				create_table :risu_family_selections do |t|
					t.integer :policy_id
					t.string :family_name
					t.string :status
				end

				create_table :risu_reports do |t|
					t.integer :policy_id
					t.string :name
				end

				create_table :risu_hosts do |t|
					t.integer :report_id
					t.string :name
					t.string :os
					t.text :mac, limit: 4294967295
					t.datetime :start
					t.datetime :end
					t.string :ip
					t.string :fqdn
					t.string :netbios
					t.text :notes
					t.integer :risk_score
				end

				create_table :risu_host_properties do |t|
					t.integer :host_id
					t.string :name
					t.text :value, limit: 4294967295
				end

				create_table :risu_items do |t|
					t.integer :host_id
					t.integer :plugin_id
					t.integer :attachment_id
					t.text :plugin_output, limit: 4294967295
					t.integer :port
					t.string :svc_name
					t.string :protocol
					t.integer :severity
					t.string :plugin_name
					t.boolean :verified
					t.text :cm_compliance_info, limit: 4294967295
					t.text :cm_compliance_actual_value, limit: 4294967295
					t.text :cm_compliance_check_id, limit: 4294967295
					t.text :cm_compliance_policy_value, limit: 4294967295
					t.text :cm_compliance_audit_file, limit: 4294967295
					t.text :cm_compliance_check_name, limit: 4294967295
					t.text :cm_compliance_result, limit: 4294967295
					t.text :cm_compliance_output, limit: 4294967295

					t.text :cm_compliance_reference, limit: 4294967295
					t.text :cm_compliance_see_also, limit: 4294967295
					t.text :cm_compliance_solution, limit: 4294967295

					t.integer :real_severity
					t.integer :risk_score
				end

				create_table :risu_plugins do |t|
					t.string :plugin_name
					t.string :family_name
					t.text :description, limit: 4294967295
					t.string :plugin_version
					t.datetime :plugin_publication_date
					t.datetime :plugin_modification_date
					t.datetime :vuln_publication_date
					t.string :cvss_vector
					t.float :cvss_base_score
					t.string :cvss_temporal_score
					t.string :cvss_temporal_vector
					t.string :exploitability_ease
					t.string :exploit_framework_core
					t.string :exploit_framework_metasploit
					t.string :metasploit_name
					t.string :exploit_framework_canvas
					t.string :canvas_package
					t.string :exploit_available
					t.string :risk_factor
					t.text :solution, limit: 4294967295
					t.text :synopsis, limit: 4294967295
					t.string :plugin_type
					t.string :exploit_framework_exploithub
					t.string :exploithub_sku
					t.string :stig_severity
					t.string :fname
					t.string :always_run
					t.string :script_version
					t.string :d2_elliot_name
					t.string :exploit_framework_d2_elliot
					t.string :exploited_by_malware
					t.boolean :rollup
					t.integer :risk_score
					t.string :compliance
					t.string :root_cause
					t.string :agent
					t.boolean :potential_vulnerability
					t.boolean :in_the_news
					t.boolean :exploited_by_nessus
					t.boolean :unsupported_by_vendor
					t.boolean :default_account
				end

				create_table :risu_individual_plugin_selections do |t|
					t.string :policy_id
					t.integer :plugin_id
					t.string :plugin_name
					t.string :family
					t.string :status
				end

				create_table :risu_references do |t|
					t.integer :plugin_id
					t.string :reference_name
					t.text :value
				end

				create_table :risu_attachments do |t|
					t.integer :item_id
					t.string :name
					t.string :ttype
					t.string :ahash
					t.text :value
				end

				create_table :risu_versions do |t|
					t.string :version
				end

				create_table :risu_service_descriptions do |t|
					t.string :name
					t.integer :port
					t.string :description
				end

				create_table :risu_patches do |t|
					t.integer :host_id
					t.string :name
					t.string :value
				end

				#Index's for speed increases, possibly have these apply after parsing @TODO
				add_index :risu_items, :host_id
				add_index :risu_items, :plugin_id
				add_index :risu_references, :plugin_id

				#Default data for service descriptions
				#@TODO Unused ATM, might be better to use a yaml file tho..
				# ServiceDescription.create :name => "www", :description => ""
				# ServiceDescription.create :name => "cifs", :description => ""
				# ServiceDescription.create :name => "smb", :description => ""
				# ServiceDescription.create :name => "netbios-ns", :description => ""
				# ServiceDescription.create :name => "snmp", :description => ""
				# ServiceDescription.create :name => "ftp", :description => ""
				# ServiceDescription.create :name => "epmap", :description => ""
				# ServiceDescription.create :name => "ntp", :description => ""
				# ServiceDescription.create :name => "dce-rpc", :description => ""
				# ServiceDescription.create :name => "telnet", :description => ""
			end

			# Deletes all of the database tables created
			#
			def self.down
				drop_table :risu_policies
				drop_table :risu_server_preferences
				drop_table :risu_plugins_preferences
				drop_table :risu_family_selections
				drop_table :risu_individual_plugin_selections
				drop_table :risu_reports
				drop_table :risu_hosts
				drop_table :risu_items
				drop_table :risu_plugins
				drop_table :risu_references
				drop_table :risu_versions
				drop_table :risu_service_descriptions
				drop_table :risu_patches
				drop_table :risu_host_properties
				drop_table :risu_attachments
			end
		end
	end
end
