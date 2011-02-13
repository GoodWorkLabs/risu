# encoding: utf-8

module NessusDB
	
	# NessusDB Schema
	#
	# @author Jacob Hammack <jacob.hammack@hammackj.com>
	class Schema < ActiveRecord::Migration

		# Creates all of the database tables required by the parser
		# 
		def self.up
			create_table :policies do |t|
				t.string :name
				t.string :comments
			end
		
			create_table :server_preferences do |t|
				t.integer :policy_id
				t.string :name
				t.string :value
			end		
		
			create_table :plugins_preferences do |t|
				t.column :policy_id, :integer
				t.column :plugin_id, :integer
				t.column :plugin_name, :string
				t.column :fullname, :string
				t.column :preference_name, :string
				t.column :preference_type, :string
				t.column :preference_values, :string
				t.column :selected_values, :string
			end

			create_table :family_selections do |t|
				t.column :policy_id, :integer
				t.column :family_name, :string
				t.column :status, :string
			end		
				
			create_table :reports do |t|
				t.column :policy_id, :integer
				t.column :name, :string
			end
		
			create_table :hosts do |t|
				t.column :report_id, :integer
				t.column :name, :string
				t.column :os, :string
				t.column :mac, :string
				t.column :start, :datetime
				t.column :end, :datetime
				t.column :ip, :string
				t.column :fqdn, :string
				t.column :netbios, :string
				t.column :local_checks_proto, :string
				t.column :smb_login_used, :string
				t.column :ssh_auth_meth, :string
				t.column :ssh_login_used, :string
				t.column :pci_dss_compliance, :string
			end
	
			create_table :items do |t|
				t.column :host_id, :integer
				t.column :plugin_id, :integer
				t.column :plugin_output, :text
				t.column :port, :integer
				t.column :svc_name, :string
				t.column :protocol, :string
				t.column :severity, :integer
				t.column :verified, :boolean
			end 
		
			create_table :plugins do |t|
				t.column :plugin_name, :string
				t.column :family_name, :string
				t.column :description, :text
				t.column :plugin_version, :string
				t.column :plugin_publication_date, :datetime
				t.column :vuln_publication_date, :datetime
				t.column :cvss_vector, :string
				t.column :cvss_base_score, :string
				t.column :cvss_temporal_score, :string
				t.column :cvss_temporal_vector, :string
				t.column :exploitability_ease, :string
				t.column :exploit_framework_core, :string
				t.column :exploit_framework_metasploit, :string
				t.column :metasploit_name, :string
				t.column :exploit_framework_canvas, :string
				t.column :canvas_package, :string
				t.column :exploit_available, :string
				t.column :risk_factor, :string
				t.column :solution, :text
				t.column :synopsis, :text
			end
			
			create_table :individual_plugin_selections do |t|
				t.column :policy_id, :string
				t.column :plugin_id, :integer
				t.column :plugin_name, :string
				t.column :family, :string
				t.column :status, :string
			end
		
			create_table :references do |t|
				t.column :plugin_id, :integer
				t.column :reference_name, :string
				t.column :value, :string
			end
	
			create_table :versions do |t|
				t.column :version, :string
			end
		end
	
		# Deletes all of the database tables created
		#
		def self.down
			drop_table :policies
			drop_table :server_preferences
			drop_table :plugins_preferences
			drop_table :family_selections
			drop_table :individual_plugin_selections
			drop_table :reports
			drop_table :hosts
			drop_table :items
			drop_table :plugins
			drop_table :references
			drop_table :versions
		end

	end
end