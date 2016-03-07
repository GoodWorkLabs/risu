# TODO

**Release dates and road map are estimates, and features can be changed at any time.**

# Bugs
*** OS's with 2000 or XP can be misidentified by Nessus showing both host messing up some of the graphs. ***

Idea for more debug information
<!-- module Nanoc
  # @return [String] A string containing information about this Nanoc version
  #   and its environment (Ruby engine and version, Rubygems version if any).
  #
  # @api private
  def self.version_information
    gem_info = defined?(Gem) ? "with RubyGems #{Gem::VERSION}" : 'without RubyGems'
    engine   = defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
    res = ''
    res << "Nanoc #{Nanoc::VERSION} © 2007-2015 Denis Defreyne.\n"
    res << "Running #{engine} #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) on #{RUBY_PLATFORM} #{gem_info}.\n"
    res
  end

  # @return [Boolean] True if the current platform is Windows, false otherwise.
  #
  # @api private
  def self.on_windows?
    RUBY_PLATFORM =~ /windows|bccwin|cygwin|djgpp|mingw|mswin|wince/i
  end
end -->

# Known Issues
- http://stackoverflow.com/questions/19040932/rmagick-complaining-about-libmagickcore-5-dylib-not-found-in-osx

- http://www.railsbling.com/posts/fix_nokogiri_warning/

# Road map

## 1.8.x (??)
- Move Default Credentials related stuff to Risu::TemplateHlpers::DefaultCredentials
- Add Mock data for
	- plugin.exploitability_ease == "Exploits are available"
	- plugin 58133 WSUS data
	- pci-dss-compliance - passed | failed
- Screenshots
	- Risu Console with Host.first
	- Risu Command line risu -l
	- Sample NessusReports from Metasploitable2 Scan
		- pngs of a few pages
		- put sample PDFs in docs/sample_reports
- Create docs/KNOWN_ISSUES.markdown
	- detail rmagick bug
	- detail nokogiri warning
- Move NEWS.markdown to docs/
- **TAG** New XML element detected: fedora.
- **BUG** dropping tables when there are no tables causes stacktrace, catch this.
- Microsoft Windows 2003 Approaching End Of Life - 80120
- Add windows 10 support
	- Host model
	- Graphs
- build Contributing doc ex: https://github.com/colszowka/simplecov/blob/master/CONTRIBUTING.md
- template arguments
- *remove OSVDB|BID from tech findings template*
- Do all the @TODO / @fix  items!
- All installation documents have been updated on the wiki
- move project page on arxopia/project/risu to hammackj/risu
- move unsupported os to Risu::TemplateHelper::UnsupportedOSXXX
- patch summary plugin - 66334
- unsupported software
	- 55786
- detected services
- Template arguments
- Host
	- Hosts with Critical / High order by count
- Item
	- search_plugin_output (keyword)
- Shares
	- Item
		- Anonymous NFS count
		- Anonymous NFS text
	- Text for describing these 3 findings with counts
- create template -n --new-template cli option, guided INPUT name, author, description via stdin then generate valid template
- Ability to load templates for the current working directory
- configuration management
- optional report prefix in risu.cfg
- Speed of parsing / etc
- *findings_by_host_summary template*
	- 1 Host per page
	- graph vulns per host
	- top 5 vulns per post
- *findings_host_detailed template*
  -vuln by host
    -hosts.each
      - host.items.each
        - name
        - synopsis
        - description
        - solution
        - risk
        - reference
        - ports
        - plugin output
- add postgres support and tests for it
- Parse summary # hosts, time / etc
- ability to query for all remote/local checks and build a report off that
- concept of template specific settings in the template file
- test for Item.notable_order_by_cvss_raw
	- ensure order is correct
- Risu::TemplateHelpers::MalwareHelper
	- has_malware_finding?
	- hosts_infected
	- hosts_not_infected
- Risu::Graphs::Malware
		- Infected vs Non-infected Pie Graph
		-
- *Malware report template*
	- Malware plugin ids =
	- 64687, APT1 malware
	- 64788, Bit9 signed malware
	- 59275, Malicious Process Detection plugin
	- 59641, Malicious process detection: unwanted software
	- 52670, Website link malware
	- 66391, Linux/Cdorked.A backdoor
	- XXXXX, Conficker Worm Detection (uncredentialed check)
	- 70767,
- tech findings report each host for plugin output
- Documents
	- Template Tutorial
	- Updating tutorial

## 1.8.1+
- compliance plugins xml parser test?
- error check connection fail on the console to mysql
- migration error handling
  - catch mysql/sqlite/postgres errors during up/down
  - better integration with mysql/post/sqlite
  - catch mysql cannot connect exception
- Console
	- list scan in database via cli
	- add a way to generate reports from the console
	- add a way to spawn mysql/psql shell to the database
	- add tables for the OS data
	- prompt for password?
	- generate report based on scan_id/report id
- finding summary: crit/high spacing
- filter (uncredentialed check) from the title of MS vulns and put it in the body as a true/false kind of field
	- remove KB # also
- create an api determining vulnerability % based on the network
- create an api for creating a vulnerability score per host to show a risk %
- add scanner info at a table plugin #19506
- Test Data
	- test data for Item.ms_patches
	- test data for References need real reference, for regex check
- Templates
	- MS AV errors (52544)
	- MS Pending Reboot report (35453)
	- findings by host report
	- unsupported OS first paragraph pluralization
	- remove ms patches from notable findings
	- add missing ms patch section
- Add a filtering system for lowering the rating of plugins based on config
	- Implement the ability to filter data out of the report
		- Filter on
			- Host Mac Address
			- Host IP
			- Plugin ID
			- Host id
		- Arbitrary number of filters
		- Add filtered API, to use the filters
			- Option 1: eg critical_risks_filtered()
			- Option 2: eg critical_risks(:filtered => true)
			- ALLOW CIDR BASED RANGES
- rewrite text for risks by severity
- Abstract the api for prawn to support different renders
- DSL for report creation to abstract the reports to have different output types
- Language abstraction for text generation
- Look at moving to Nokogiri for xml parsing; http://nokogiri.org if its faster
- Implement different renderer's
	- html
	- rtf
	- OpenOffice.org xml
- Service Descriptions

## Ideas
### Core
- bug report info collection option
- Complete comments for all existing code
- More text generation from graphs
- pdf bookmarks / Table of Contents
- rewrite the application class
- check the config file for \t
- add create template option

### Parsers
- *Normalize the Schema to accomidate multiple scanners*
- Move all pci related host properties to their own table
- Create a Nessus document generator, for testing the parser
- Add Schema checks to make sure the schema is compatible with the version of risu
- Add Importer for Nessus SQLite Database Format
	- Requires decryption of the sqlite database
- *Add Parser for OpenVas Output*
- Add Parser for SecurityCenter Output
- Add Parser for Nexpose XML [Simple, Detailed]
- Add Parser for Qualys XML
- *Add Parser for Nmap XML*
- Add Parser for SAINT XML

###Models
- add hosts with crit/high/med/low queries
- add ibm to the os named_scopes

###Graphs
- *Move all graphs under Risu::Graphs*
- most common os graph
- vulns by service bar chart
- most common services graph
- most common vuln category
- # hosts by severity
- stig bar graph for cat 1 / 2 / 3
- unsupported vs supported os graph
- Add a CVSS risk factor graph
	- Item.joins(:plugin).group(:cvss_base_score).order("plugins.cvss_base_score DESC").limit(10).size
- security risk graph
- detailed linux graph
- detailed windows graph
- uniform graph colors
- vuln count by host graph top 10 vulns
- generate a graph matirx like exec summary detailed
- malware infection graph

###NessusReports / Templates
- Easier way to select the Scan to generate reports from
- Unsupported OS report
	- http://windows.microsoft.com/en-us/windows/lifecycle
	- XP SP3 = April 8, 2014
	- Vista SP2 = April 11, 2017
	- 7 = January 14, 2020
	- 8 = January 10, 2023
	- 10 = October 14, 2025
	- 2003 =
	- 2008 =

- NessusReports based on audit data
- NessusReports for mobile information
- web server statics report (plugin id)
- virtual machine stats report (20094)
- add pdf bookmarks to reports
- talking point report
- add netbios name to IPs (hostname)
- add table of contents on the tech findings template
- better exec template
	- intro
			- over view
			- details of major findings (3-5)
	- scope
	- impact of threats (generalized)
	- graphs
- SANS TOP XX report
- Fix list report
	- by host ordered by risk
		- vulnerability name
		- first cve
		- Host
		- vuln name     |   cve
		- vuln name     |   cve
- add findings by host report
- windows policy report
- clean up old templates, some are nasty
- stig detailed report
	-http://www.scribd.com/doc/3752867/6/Vulnerability-Severity-Code-Definitions
	- Category I
		- Vulnerabilities that allow an attacker immediate access into a machine, allow superuser access, or bypass a firewall.These can lead to the immediate compromise of the web server allowing the attacker to take complete control of the web server and associated operating system, which can then be used as a resource to control other systems in your network.Some examples would be the running of unsupported software, anonymous access to privileged accounts, and the presence of sample applications installed on the web server.
	- Category II
		- Vulnerabilities aide the ability of an attacker to gain access into a machine, compromise sensitive data, or bypass a firewall.These will lead to the eventual compromise of the web server allowing the attacker to manipulate the content or server settings on the web server and have access to other systems in your network.Some examples would be trust relationships with unauthorized separate enclaves, non compliance with appropriate host operating system security controls, and the non compliance with the IAVM program.
	- Category III
		- Vulnerabilities that impact the security posture of the system and if configured, will improve the overall security of asset.These could result in the degradation of service, compromise of information, and in some cases lead to unauthorized access to the system. Some examples would be untrained staff, development tools on a production environment, and the uncontrolled release of information to the web server.
- template for rhs plugins
- template for wsus plugins
- Update Assets templates to use this if possible plugin: http://www.nessus.org/plugins/index.php?view=single&id=54615 for extra data
- Ensure font sizes are standard in the templates
- The font in tech findings could be 1 size smaller
- add more detailed pci templates
- Provide more templates
	- Virtual Machine Summary
	- Fix list NessusReport?
	- Compact the data in tech findings to be more printer friendly
	- finding summary coversheet looks odd
	- [TEMPLATE] unsupported OS template
	- [API] add list of unsupported os ip's accessors
	- [TEMPLATE] detailed findings should be combined to save paper on printing
	- Sort Technical Findings NessusReport by count/score
	- Add template validation and more error checking
- Added TOC/Index to the technical findings report, issue 15
- More text blocks for various plugins services
- finish implementation of service descriptions
- outstanding / very good / good / improvement needed / unsatisfactory
- report type rtf
  Per host
    - scan time start/end
    - remote host info is/netbios/name/dns/ip/mac

### Testing
- Create tests for everything (95%+ code coverage goal, % Current)
	- Parser tests
		- Add test for new XML element
		- Add test for new host properties tag
	- Model Tests
		- NessusReport
		- Item
		- Host
	- Application specs
		- Add a failed load_config() test
		- add test for load config from file
		- add test for non existent config file
	- Template specs
		- Assets
		- Coversheet
		- exec summary
		- executive summary(detailed)
		- finding stats
		- findings host
		- findings summary
		- findings summary with plugin id
		- host summary
		- ms patch summary
		- ms update summary
		- pci compliance
		- tech findings
- Add tests for Patch model

### Marketing
- Kali Linux setup Tutorial
- Ubuntu LTS setup Tutorial
- Presentation on Risu
- Centos 7 setup

#### Website
- Update github pages

#### Documentation
- add hacking doc
- config file docs
