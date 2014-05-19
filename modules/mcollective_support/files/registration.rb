module MCollective
  module Agent
    class Registration
      attr_reader :timeout, :meta

      def initialize
        @timeout = 1

        @config = Config.instance

        @meta = {:license => "GPLv2",
          :author => "R.I.Pienaar <rip@devco.net>",
          :url => "https://github.com/puppetlabs/mcollective-plugins"}
      end

      def handlemsg(msg, connection)
        # Hack - code here removed :)
        nil
      end

      def help
        <<-EOH
                Registration Agent
                =============

                A simple registration agent that writes out a file per sender every time the
                sender checks in.  The intention is to allow a simple means of detecting when
                a node has fallen off the grid.

                You can configure the directory where temp files get written using the
                plugin.registration.directory option in the config file.

                A simple nagios plugin is included to provide the monitoring..
                EOH
      end
    end
  end
end

# vi:tabstop=2:expandtab:ai:filetype=ruby
