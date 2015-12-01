# Copyright (c) 2010-2016 Arxopia LLC.
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
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

require 'test_helper'

class NessusDocumentTest < ActiveSupport::TestCase

	def setup
		setup_test_database
	end

	test "should return false for NessusDocument.valid? when the document doesn't exist" do
		fail_doc = Risu::Parsers::Nessus::NessusDocument.new "test_data/non_existant_nessus_file.nessus"
		assert fail_doc.valid? == false
	end

	test "should return false for NessusDocument.valid? when the document is invalid" do
		invalid_nessus_file = "
		<?xml version=\"1.0\"?>
		<NessusClientData>
			<Policy>
				<policyName>Fake Policy</policyName>
				<policyComments/>
				<Preferences>
					<ServerPreferences></ServerPreferences>
			</Policy>
		</NessusClientData"

		invalid_doc = Risu::Parsers::Nessus::NessusDocument.new invalid_nessus_file
		assert invalid_doc.valid? == false
	end
end
