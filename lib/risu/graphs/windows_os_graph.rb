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
	module Graphs

		# TopVulnGraph
		#
		class TopVulnGraph
			def graph
        g = Gruff::Pie.new(GRAPH_WIDTH)
        g.title = "Windows Operating Systems By Percentage"
        g.sort = false
        g.marker_count = 1
        g.theme = {
          :colors => Risu::GRAPH_COLORS,
          :background_colors => %w(white white)
        }

        nt = Host.os_windows_nt.to_a.count
        w2k = Host.os_windows_2k.to_a.count
        xp = Host.os_windows_xp.to_a.count
        w2k3 = Host.os_windows_2k3.to_a.count
        vista = Host.os_windows_vista.to_a.count
        w2k8 = Host.os_windows_2k8.to_a.count
        w2k12 = Host.os_windows_2k12.to_a.count
        w7 = Host.os_windows_7.to_a.count
        w8 = Host.os_windows_8.to_a.count
        other = (Host.os_windows.os_windows_other).to_a.count

        g.data("NT", nt) if nt >= 1
        g.data("2000", w2k) if w2k >= 1
        g.data("XP", xp) if xp >= 1
        g.data("Server 2003", w2k3) if w2k3 >= 1
        g.data("Vista", vista) if vista >= 1
        g.data("Server 2008", w2k8) if w2k8 >= 1
        g.data("Server 2012", w2k12) if w2k12 >= 1
        g.data("7", w7) if w7 >= 1
        g.data("8", w8) if w8 >= 1
        g.data("Other Windows", other) if other >= 1

        StringIO.new(g.to_blob)
      end

      def text
        nt = Host.os_windows_nt.to_a.count
        w2k = Host.os_windows_2k.to_a.count
        xp = Host.os_windows_xp.to_a.count
        w2k3 = Host.os_windows_2k3.to_a.count
        vista = Host.os_windows_vista.to_a.count
        w2k8 = Host.os_windows_2k8.to_a.count
        w2k12 = Host.os_windows_2k12.to_a.count
        w7 = Host.os_windows_7.to_a.count
        w8 = Host.os_windows_8.to_a.count
        other = (Host.os_windows.os_windows_other).to_a.count

        windows_os_count = nt + w2k + xp + w2k3 + vista + w7 + w8 + w2k8 + w2k12 + other

        nt_percent = (nt.to_f / windows_os_count.to_f) * 100
        w2k_percent = (w2k.to_f / windows_os_count.to_f) * 100
        xp_percent = (xp.to_f / windows_os_count.to_f) * 100
        w2k3_percent = (w2k3.to_f / windows_os_count.to_f) * 100
        vista_percent = (vista.to_f / windows_os_count.to_f) * 100

        w2k8_percent = (w2k8.to_f / windows_os_count.to_f) * 100
        w7_percent = (w7.to_f / windows_os_count.to_f) * 100
        w8_percent = (w8.to_f / windows_os_count.to_f) * 100
        w2k12_percent = (w2k12.to_f / windows_os_count.to_f) * 100

        text = "This graph shows the percentage of the different Microsoft Windows based operating systems " +
        "found on the #{Report.title} network.\n\n"

        text << "#{nt_percent.round.to_i}% of the network is Windows NT. " if nt_percent >= 1
        text << "#{w2k_percent.round.to_i}% of the network is Windows 2000. " if w2k_percent >= 1
        text << "#{xp_percent.round.to_i}% of the network is Windows XP. " if xp_percent >= 1
        text << "#{w2k3_percent.round.to_i}% of the network is Windows Server 2003. " if w2k3_percent >= 1
        text << "#{vista_percent.round.to_i}% of the network is Windows Vista. " if vista_percent >= 1
        text << "#{w2k8_percent.round.to_i}% of the network is Windows Server 2008. " if w2k8_percent >= 1
        text << "#{w7_percent.round.to_i}% of the network is Windows 7. " if w7_percent >= 1
        text << "#{w8_percent.round.to_i}% of the network is Windows 8. " if w8_percent >= 1
        text << "#{w2k12_percent.round.to_i}% of the network is Windows Server 20012. " if w2k12_percent >= 1

        text << "\n\n" << unsupported_os_windows if nt > 0 or w2k > 0

        return text
      end

      #
      # @TODO comments
      #
      def has_data?
        nt = Host.os_windows_nt.to_a.size
        w2k = Host.os_windows_2k.to_a.size
        xp = Host.os_windows_xp.to_a.size
        w2k3 = Host.os_windows_2k3.to_a.size
        vista = Host.os_windows_vista.to_a.size
        w2k8 = Host.os_windows_2k8.to_a.size
        w2k12 = Host.os_windows_2k12.to_a.size
        w7 = Host.os_windows_7.to_a.size
        w8 = Host.os_windows_8.to_a.size
        other = (Host.os_windows.os_windows_other).to_a.size

        if nt == 0 && w2k == 0 && xp == 0 && w2k3 == 0 && vista == 0 && w2k8 == 0 && w2k12 == 0 && w7 == 0 && w8 == 0 && other == 0
          return false
        else
          return true
        end
      end
		end
	end
end
